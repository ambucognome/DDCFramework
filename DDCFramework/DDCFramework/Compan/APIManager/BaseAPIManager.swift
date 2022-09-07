//
//  BaseAPIManager.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/29/22.
//

import Foundation
import UIKit
import Alamofire

class BaseAPIManager : NSObject {
    
    // Shared Instance
    static let sharedInstance = BaseAPIManager()
    
    // MARK: URLRequestConvertible
    enum Router: URLRequestConvertible {
        
        // Api Base Url fron Constant
        static let baseURLString = FLOW_BASE_URL

        //User
        case loginUser(Data)
        case startSurvey(Data,String)
        case completeSurvey(Data)

        // Api Methods
        var method: HTTPMethod {
            switch self {
            case .loginUser:
                return .post
            case .startSurvey:
                return .post
            case .completeSurvey:
                return .post
            }
        }
            
        // Get the URL path
        var path: String {
            switch self {
            case .loginUser:
                return API_END_LOGIN
            case .startSurvey:
                return API_END_START_SURVEY
            case .completeSurvey:
                return API_END_COMPLETE_SURVEY
            }
        }
        
        //Generates a URL request object with the token embeded in the header.
        func asURLRequest() throws -> URLRequest {
            let url = try Router.baseURLString.asURL().appendingPathComponent(path)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var urlTokenRequest = URLRequest(url: url)
            urlTokenRequest.httpMethod = method.rawValue
            urlTokenRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlTokenRequest.setValue("Bearer \(Utilities.getToken())", forHTTPHeaderField: "Authorization")
            
            switch self {
            case .loginUser(let data):
                urlRequest.httpBody = data
                return urlRequest
            case .startSurvey(let data,let isForced):
                let postUrl = try Router.baseURLString.asURL().appendingPathComponent(path)
                var url = URLComponents(string: postUrl.absoluteString)!
                if isForced == "true" {
                let isForced = URLQueryItem(name: "isForced", value: isForced)
                url.queryItems = [isForced]
                }
                urlRequest = URLRequest(url: url.url!)
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(Utilities.getToken())", forHTTPHeaderField: "Authorization")
                urlRequest.httpMethod = method.rawValue
                urlRequest.httpBody = data
                return urlRequest
                
                return urlTokenRequest
            case .completeSurvey(let data):
                urlTokenRequest.httpBody = data
                return urlTokenRequest
            }
        }
    }
    
        
    // Completion Handlers
    typealias completionHandlerWithSuccess = (_ success:Bool) -> Void
    typealias completionHandlerWithSuccessAndErrorMessage = (_ success:Bool, _ errorMessage: String) -> Void
    typealias completionHandlerWithSuccessAndMessage = (_ success:Bool,_ message: NSDictionary) -> Void
    typealias completionHandlerWithResponse = (HTTPURLResponse) -> Void
    typealias completionHandlerWithResponseAndError = (HTTPURLResponse?, NSError?) -> Void
    typealias completionHandlerWithSuccessAndResultArray = (_ success:Bool, _ results: NSArray) -> Void
    typealias completionHandlerWithSuccessAndResultsArray = (_ success:Bool, _ result_1: NSArray, _ result_2: NSArray) -> Void
    typealias completionHandlerWithStatusCode = (_ success:Bool,_ message: NSDictionary,_ statusCode: Int) -> Void
    typealias completionHandlerWithBoolAndStatusCode = (_ success:Bool,_ message: Bool,_ statusCode: Int) -> Void

        
    // Login User
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToLoginUser(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.loginUser(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }   else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Start survey
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToStartSurvey(data:Data,isForced:String,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.startSurvey(data,isForced)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }   else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    
    // Complete survey
    // completion : Completion object to return parameters to the calling functions
    // Returns User details
    func makeRequestToCompleteSurvey(data:Data,completion: @escaping completionHandlerWithStatusCode) {
        Alamofire.request(Router.completeSurvey(data)).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                ERProgressHud.shared.hide()
                let statusCode = response.response?.statusCode
                guard let jsonData =  JSON  as? NSDictionary else {
                    APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
                    return
                }
                if statusCode == SUCCESS_CODE_200{
                    completion(true, jsonData, statusCode!)
                }   else {
                    APIManager.sharedInstance.showAlertWithMessage(message: self.choooseMessageForErrorCode(errorCode: statusCode!))
                }
            case .failure( _):
                completion(false,[:],0)
            }
        }
    }
    

    
    // Shows alert view according to the code sent
    // Params:
    // code:code is the response code sent from the server.
    func showAlertWithCode(code:Int)  {
        let alertView = UIAlertController(title: "Alert",message: self.choooseMessageForErrorCode(errorCode: code) as String, preferredStyle:.alert)
        alertView.setTint(color: PURPLE)
        alertView.setBackgroundColor(color: .white)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        var vc = window.rootViewController;
        while (vc!.presentedViewController != nil){
            vc = vc!.presentedViewController;
        }
        vc?.present(alertView, animated: true, completion: nil)
    }
    
    // Shows alert view with the message sent
    // Params:
    // message is the text to shown in the alert view.
    func showAlertWithMessage(message:String)  {
        var alertView = UIAlertController(title: nil,
                                          message: message, preferredStyle:.alert)
        alertView.setTint(color: PURPLE)
        alertView.setBackgroundColor(color: .white)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        var vc = window.rootViewController;
        while (vc!.presentedViewController != nil){
            vc = vc!.presentedViewController;
        }
        vc?.present(alertView, animated: true, completion: nil)
    }
    
    // Method for Error Code with Proper Appropriate String
    // Params:
    // errorCode:errorCode is the response code sent from the server.
    // Returns a String according to the error code.
    func choooseMessageForErrorCode(errorCode: Int) -> String {
        var message: String = ""
        switch errorCode {
        case SUCCESS_CODE_200:
            message = SUCCESS_MESSAGE_FOR_200
        case ERROR_CODE_400:
            message = ERROR_MESSAGE_FOR_400
            break
        case ERROR_CODE_401:
            message = ERROR_MESSAGE_FOR_401
        case ERROR_CODE_500:
            message = ERROR_MESSAGE_FOR_500
        case ERROR_CODE_503:
            message = ERROR_MESSAGE_FOR_503
        default:
            message = ERROR_MESSAGE_DEFAULT
        }
        return message;
    }
}

