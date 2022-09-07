//
//  EZLoginViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/28/22.
//

import UIKit
import Foundation
import SwiftUI


var context_parameters = [String:Any]()
var survey_data = NSDictionary()

class EZLoginViewController: UIViewController {

    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ezIdTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var normalLoginBtn: UIButton!

    
    let transition = BubbleTransition()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastNameTextField.text = "Nechis"
        self.ezIdTextField.text = "200076"
//        self.lastNameTextField.text = "Whitley"
//        self.ezIdTextField.text = "020926"
    }

    
    @IBAction func loginBtn(_ sender: Any) {
        if self.ezIdTextField.text!.isEmpty {
            self.ezIdTextField.shake()
            return
        }
        if self.lastNameTextField.text!.isEmpty {
            self.lastNameTextField.shake()
            return
        }
        self.loginAPI()
    }
    

    @IBAction func normalloginBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "EZLoginViewController") as! EZLoginViewController
//        vc.transitioningDelegate = self
//        vc.modalPresentationCapturesStatusBarAppearance = true
//        vc.modalPresentationStyle = .custom
//        self.present(vc, animated: true, completion: nil)
    }
    
    func loginAPI(){
        ERProgressHud.shared.show()
        let parameters : [String: String] = [ "eid" : self.ezIdTextField.text!,"lastname": self.lastNameTextField.text!,"loginType": "EZ-ID" ]
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
                                         let storyboard = UIStoryboard(name: "covidCheck", bundle: nil)
                                          let vc = storyboard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
                                          self.navigationController?.pushViewController(vc, animated: true)
                                          
                                      } catch {
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

extension EZLoginViewController : UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .present
      transition.startingPoint = normalLoginBtn.center
      transition.bubbleColor = normalLoginBtn.backgroundColor!
      return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      transition.transitionMode = .dismiss
      transition.startingPoint = normalLoginBtn.center
      transition.bubbleColor = normalLoginBtn.backgroundColor!
      return transition
    }
}
