//
//  ERProgressHud.swift
//  Compan
//
//  Created by Ambu Sangoli on 10/05/22.
//

import UIKit
import SwiftyGif
import Lottie

class ERProgressHud: NSObject  {
    // MARK: Shared Instance
    
    static let shared = ERProgressHud()
    
    //MARK: Member Variables
    
//    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
//    let containerView = UIView()
//    let progressDialogue = UILabel()
//    let dialogueContainerView = UIView()
    
    
    let containerView = UIView()
    let gifImageView = UIImageView()

    let animationView = AnimationView()
    let loadingLabel = UILabel()

    
    // show the progress view
//    func show() {
//        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
//        let color = UIColor.gray
//        let alphaColor = color.withAlphaComponent(0.5)
//        containerView.backgroundColor = alphaColor
//        activityIndicator.center =  CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
//        activityIndicator.color = UIColor.white
//        activityIndicator.hidesWhenStopped = true
//
//        if let window :UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
//            containerView.addSubview(activityIndicator)
//            window.addSubview(containerView)
//            activityIndicator.startAnimating()
//        }
//    }
//
//    // hide the progress view
//    func hide() {
//        activityIndicator.stopAnimating()
//        containerView.removeFromSuperview()
//    }
    
    // show
    func show() {
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        containerView.backgroundColor = .clear
        gifImageView.frame.size = CGSize(width: 80, height: 80)
        gifImageView.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        gifImageView.contentMode = .scaleAspectFit
        do {
            let gifImage = try UIImage(gifName: "Loader.gif")
            gifImageView.setGifImage(gifImage)
//            view.addSubview(containerView)
            if let window :UIWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                containerView.addSubview(gifImageView)
                window.addSubview(containerView)
                gifImageView.startAnimatingGif()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // hide
    func hide() {
        gifImageView.stopAnimatingGif()
        gifImageView.removeFromSuperview()
        containerView.removeFromSuperview()
    }
    
    
    
    // Get container view
    func getContainerView() -> UIView {
        return containerView
    }
}


