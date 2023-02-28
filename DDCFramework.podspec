Pod::Spec.new do |spec|

 spec.name         = "DDCFramework"
   spec.version      = "1.0.17"
     spec.requires_arc = true
   spec.summary      = "This is form framework"
   spec.description  = "Framework for form module"
  spec.homepage     = "https://github.com/ambucognome/DDCFramework"
  spec.license      = "MIT"
  spec.author       = { "Ambu Sangoli" => "ambu@cognome.in" }
  spec.platform     = :ios, "14.0"
  spec.source       = { :git => "https://github.com/ambucognome/DDCFramework.git", :tag => spec.version.to_s }
    #spec.source_files  = "DDCFramework/**/**"
        spec.source_files = "DDCFramework/**/*.{swift}"
        spec.resources = "DDCFramework/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    
    spec.framework  = "UIKit"
    #spec.dependency "KXJsonUI"
    spec.dependency "Alamofire", "~> 4.7"
    spec.dependency "SCLAlertView"
    spec.dependency "NVActivityIndicatorView"
    spec.dependency "BiometricAuthentication"
    spec.dependency "KeychainSwift", "~> 11.0"
    spec.dependency "SwiftyJSON"
    spec.dependency "DropDown"
    spec.dependency "IQKeyboardManagerSwift"
    spec.dependency "SwiftyGif"
    spec.dependency "lottie-ios"
    spec.dependency "SwiftyMenu", "~> 1.0.1"
    spec.dependency "SelectionList"
    #spec.dependency "DatePickerDialog"
    spec.dependency "NotificationBannerSwift", "~> 3.0.0"
    
    spec.swift_version = "5.5.1"
end
