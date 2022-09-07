//
//  InitialViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 25/08/22.
//

import UIKit



class InitialViewController: UIViewController, DynamicTemplateViewControllerDelegate {
    
    var surveyStartTime = ""
    var surveyID = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        self.startSurvey()
        self.navigationController?.isNavigationBarHidden = true
        self.addObservers()
    }
    deinit {
        removeObservers()
    }

    func addObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationAction),
            name: NSNotification.Name(rawValue: "ReloadAPI") ,
            object: nil
        )
    }

    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"ReloadAPI"), object: nil)
    }
    
    @objc func notificationAction() {
        if let retrievedCodableObject = UserDefaults.standard.codableObject(dataType: LoginModel.self, key: LOGIN_DATA) {
        let context = [
        "survey_id" : surveyID,
        "user": retrievedCodableObject.user?.eid ?? ""
        //,"timestamp": surveyStartTime
   ]
           
        self.getTempleWith(author: "System", uri: templateURI, context: context)
        }
      }
    
    func didSubmitSurvey(params: [String : Any]) {
        print("survey completed")
//        SurveyHelper.shared.completeSurvey(surveyDetails: params)
        self.completeSurvey(surveyDetails: params)
    }
    
    func completeSurvey(surveyDetails: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: surveyDetails, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)

        
        ERProgressHud.shared.show()
                    BaseAPIManager.sharedInstance.makeRequestToCompleteSurvey( data: jsonData){ (success, response,statusCode)  in
                        if (success) {
                            ERProgressHud.shared.hide()
                            print(response)
                            if statusCode == 200 {
                                self.startSurvey()
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
                            let template_uri = response["ddc_template_uri"] as? String ?? ""
                            templateURI = template_uri
                                    if let survey = response["survey"] as? NSDictionary {
                                        survey_data = survey
                                        let surveyTime =  survey["survey_start"] as? String ?? ""
                                        let id =  survey["id"] as? NSNumber ?? 0
                                        self.surveyStartTime = Utilities.convertDateToTimestamp(date: surveyTime)
                                        self.surveyID = id.stringValue
                                        username = retrievedCodableObject.user?.firstname ?? ""
                                        let covid_employee_attestation_log_complete = survey["covid_employee_attestation_log_complete"] as? Bool ?? false

                                        let covid_19_pass_status = survey["covid_19_pass_status"] as? Int
                                        let survey_pass_status = survey["survey_pass_status"] as? Bool
                                        if covid_19_pass_status == nil && survey_pass_status == nil {
                                            //open fresh form
                                            let context = [
                                                "survey_id" : self.surveyID,
                                            "user": retrievedCodableObject.user?.eid ?? ""
//                                                , "timestamp": self.surveyStartTime
                                            ]
                                                self.getTempleWith(author: "System", uri: templateURI, context: context)
                                            return
                                        }
                                        if survey_pass_status == nil && covid_employee_attestation_log_complete == false {
                                            //completed first form but incomplete second form
                                            let context = [
                                                "survey_id" : self.surveyID,
                                            "user": retrievedCodableObject.user?.eid ?? ""
                                                //, "timestamp": self.surveyStartTime
                                                                                            ]
                                                self.getTempleWith(author: "System", uri: templateURI, context: context)
                                            return
                                        }
                                        
                                        if (covid_19_pass_status ?? 0) == 0 && (survey_pass_status ?? false) == false && covid_employee_attestation_log_complete == false {
                                            //open incomplete form
                                            let context = [
                                                "survey_id" : self.surveyID,
                                            "user": retrievedCodableObject.user?.eid ?? ""
                                                //, "timestamp": self.surveyStartTime
                                                                                            ]
                                                self.getTempleWith(author: "System", uri: templateURI, context: context)
                                            return
                                        }
                                        
                                        let surveyDay = response["day_of_survey"] as? String ?? ""
                                        let surveyDate = response["survey_date"] as? String ?? ""
                                        let surveyExpirationTime = response["survey_expiration"] as? String ?? ""

                                        let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                                        let surveyStatus = response["survey_pass_status"] as? Bool ?? false
                                        
                                        let not_cleared = response["not_cleared"] as? String ?? ""
                                        
                                        let call_manager = response["call_manager"] as? String ?? ""
                                        let who_to_call = response["who_to_call"] as? String ?? ""
                                        let number_to_call = response["number_to_call"] as? String ?? ""

                                        if covid_employee_attestation_log_complete == true {
                                            if let passStatus = covid_19_pass_status {
                                            if passStatus == 1 || passStatus == 6 || passStatus == 5 {
                                                //open pass screen
                                                let vc = storyboard.instantiateViewController(withIdentifier: "PassScreenViewController") as! PassScreenViewController
                                                vc.surveyDay = surveyDay
                                                vc.surveyDate = surveyDate
                                                vc.surveyExpirationTime = surveyExpirationTime
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            } else if passStatus == 7 || passStatus == 10 || passStatus == 3 || passStatus == 11 || passStatus == 0 {
                                                //open fail
                                                let vc = storyboard.instantiateViewController(withIdentifier: "FailScreenViewController") as! FailScreenViewController
                                                vc.surveyDay = surveyDay
                                                vc.surveyDate = surveyDate
                                                vc.notClearedText = not_cleared
                                                vc.infoText = "\(call_manager) \n\(who_to_call) \(number_to_call)"
                                                self.navigationController?.pushViewController(vc, animated: true)
                                            }
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
        context_parameters = context as! [String : Any]
        if (self.navigationController?.topViewController as? DynamicTemplateViewController) == nil {
            ERProgressHud.shared.show()
        }
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
                                          let frameworkBundle = Bundle(for: DynamicTemplateViewController.self)
                                          let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "dynamic") as! DynamicTemplateViewController
                                          vc.delegate = self
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
