//
//  DDCInitiate.swift
//  DDCFramework
//
//  Created by Ambu Sangoli on 7/14/22.
//

import Foundation
import UIKit

public struct DDCInitiate {
    
    public static func add(a:Int,b:Int) -> Int {
        return a + b
    }
    
    public static func subtract(a:Int,b:Int) -> Int {
        return a - b
    }
    
    public static func multiply(a:Int,b:Int) -> Int {
        return a * b
    }
    
    
    public static func openViewController(uri:String, author: String, context: String) {
        let frameworkBundle = Bundle(for: ViewController.self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:frameworkBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

//        vc.uri = uri
//        vc.author = author
//        vc.context = context
//        let navVc = UINavigationController(rootViewController: vc)
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
//        viewController.presentViewController(nextViewController, animated:true, completion:nil)
//        UIApplication.shared.windows.first?.rootViewController = navVc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
}

public extension UIApplication {

    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {


            return topViewController(controller: presented)
        }
        return controller
    }
}
