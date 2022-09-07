//
//  LoginViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/28/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var ezLoginBtn: UIButton!
    
    var surveyStartTime = ""
    var surveyID = ""


    let transition = BubbleTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func loginBtn(_ sender: Any) {
        if self.usernameTextField.text!.isEmpty {
            self.usernameTextField.shake()
            return
        }
        if self.passwordTextField.text!.isEmpty {
            self.passwordTextField.shake()
            return
        }
        self.loginAPI()

    }
    
    @IBAction func ezloginBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EZLoginViewController") as! EZLoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
//        vc.transitioningDelegate = self
//        vc.modalPresentationCapturesStatusBarAppearance = true
//        vc.modalPresentationStyle = .custom
//        self.present(vc, animated: true, completion: nil)
    }
    
    func loginAPI(){
        ERProgressHud.shared.show()
        let parameters : [String: String] = [ "username" : self.usernameTextField.text!,"password": self.passwordTextField.text!,"loginType": "LDAP" ]
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        BaseAPIManager.sharedInstance.makeRequestToLoginUser( data: jsonData){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(LoginModel.self, from: jsonData!)
                                          print(jsonDataModels)
                                          Utilities.setToken(token: jsonDataModels.user?.jwtToken ?? "")

                                          UserDefaults.standard.setCodableObject(jsonDataModels, forKey: LOGIN_DATA)
                                         
                                          self.startSurvey()


                                      }catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }
    
    func startSurvey() {
        ERProgressHud.shared.show()
        if let retrievedCodableObject = UserDefaults.standard.codableObject(dataType: LoginModel.self, key: LOGIN_DATA) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let orderJsonData = try! encoder.encode(retrievedCodableObject.user!)
            let jsonString = NSString(data: orderJsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            BaseAPIManager.sharedInstance.makeRequestToStartSurvey( data: orderJsonData, isForced: "false"){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if let isSurveyExists = response["completed_survey_exists"] as? Bool {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if isSurveyExists == false {
                                    if let survey = response["survey"] as? NSDictionary {
                                        let surveyTime =  survey["survey_start"] as? String ?? ""
                                        let id =  survey["id"] as? NSNumber ?? 0
                                        self.surveyStartTime = Utilities.convertDateToTimestamp(date: surveyTime)
                                        self.surveyID = id.stringValue
                                    
                                    let context = [
                                        "survey_id" : self.surveyID,
                                    "user": retrievedCodableObject.user?.eid ?? "",
                                        "timestamp": self.surveyStartTime
                               ]
                                    self.getTempleWith(author: "System", uri: "http://chdi.montefiore.org/CovidSafeCheck", context: context)
                                    }
                                } else {
                                    let surveyPassStatus = response["survey_pass_status"] as? Bool ?? false
                                    if surveyPassStatus {
                                        let vc = storyboard.instantiateViewController(withIdentifier: "PassScreenViewController") as! PassScreenViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    } else {
                                        let vc = storyboard.instantiateViewController(withIdentifier: "FailScreenViewController") as! FailScreenViewController
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                        } else {
                            APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                            ERProgressHud.shared.hide()
                        }
            }
        }
    }
    
    func getTempleWith(author: String, uri: String, context: Any) {
        let parameters: [String: Any] = [
            "author" : author,
            "template_uri" : (uri),
            "context": context
        ]
        
        APIManager.sharedInstance.makeRequestToGetTemplate(params: parameters as [String:Any]){ (success, response,statusCode)  in
            if (success) {
                ERProgressHud.shared.hide()
                print(response)
                if let responseData = response as? Dictionary<String, Any> {
                                  var jsonData: Data? = nil
                                  do {
                                      jsonData = try JSONSerialization.data(
                                          withJSONObject: responseData as Any,
                                          options: .prettyPrinted)
                                      do{
                                          let jsonDataModels = try JSONDecoder().decode(DDCFormModel.self, from: jsonData!)
                                          print(response)
                                          
                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamicTemplateViewController
                                          ddcModel = jsonDataModels
//                                          self.present(vc, animated: true, completion: nil)
                                          if (self.navigationController?.topViewController as? DynamicTemplateViewController) != nil {
                                              ScriptHelper.shared.checkIsVisibleEntity()
                                              return
                                          }
                                          
                                          self.navigationController?.pushViewController(vc, animated: true)
                                          ScriptHelper.shared.checkIsVisibleEntity()

                                      }catch {
                                          print(error)
                                      }
                                  } catch {
                                      print(error)
                                  }
                        }
            } else {
                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                ERProgressHud.shared.hide()
            }
        }
    }

    
}

extension LoginViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      transition.startingPoint = ezLoginBtn.center
      transition.bubbleColor = ezLoginBtn.backgroundColor!
      return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = ezLoginBtn.center
      transition.bubbleColor = ezLoginBtn.backgroundColor!
      return transition
    }
}
