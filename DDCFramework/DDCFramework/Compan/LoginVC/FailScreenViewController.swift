//
//  FailScreenViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 8/1/22.
//

import UIKit

class FailScreenViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notClearedLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!

    var surveyStartTime = ""
    var surveyID = ""

    var surveyDay = ""
    var surveyDate = ""
    
    var notClearedText = "NOT CLEARED"
    var infoText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.setupViews()
    }

    
    func setupViews(){
        self.dayLabel.text = surveyDay
        self.dateLabel.text = surveyDate
        self.notClearedLabel.text = notClearedText
        self.infoTextView.text = infoText
        
        if let retrievedCodableObject = UserDefaults.standard.codableObject(dataType: LoginModel.self, key: LOGIN_DATA) {
            self.nameLabel.text = (retrievedCodableObject.user?.firstname ?? "") + " " + (retrievedCodableObject.user?.lastname ?? "")
        }
    }
    
    
    
    @IBAction func startBtn(_ sender: Any) {
        self.startSurvey()
    }
    
    func startSurvey() {
        ERProgressHud.shared.show()
        if let retrievedCodableObject = UserDefaults.standard.codableObject(dataType: LoginModel.self, key: LOGIN_DATA) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let orderJsonData = try! encoder.encode(retrievedCodableObject.user!)
            let jsonString = NSString(data: orderJsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print(jsonString)
            BaseAPIManager.sharedInstance.makeRequestToStartSurvey( data: orderJsonData, isForced: "true"){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            let template_uri = response["ddc_template_uri"] as? String ?? ""
                            templateURI = template_uri
                                    if let survey = response["survey"] as? NSDictionary {
                                        survey_data = survey
                                        let surveyTime =  survey["survey_start"] as? String ?? ""
                                        let id =  survey["id"] as? NSNumber ?? 0
                                        self.surveyStartTime = Utilities.convertDateToTimestamp(date: surveyTime)
                                        self.surveyID = id.stringValue
                                        
                                    
                                            //open fresh form
                                            let context = [
                                                "survey_id" : self.surveyID,
                                            "user": retrievedCodableObject.user?.eid ?? ""
//                                                , "timestamp": self.surveyStartTime
                                            ]
                                                self.getTempleWith(author: "System", uri: templateURI, context: context)
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
        ERProgressHud.shared.show()
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
