//
//  Constants.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import Foundation
import UIKit

//Base Url
//DDC Base URL


public var BASEURL = "https://ddcbackend.azurewebsites.net/"

public let API_END_GET_TEMPLATE = "getTemplate"
public let API_END_UPDATE_ENTITY_VALUE = "updateTemplateEntity"
public let API_END_ADD_REPEATABLE_ENTITY_GROUP = "addRepeatableEntityGroup"
public let API_END_DELETE_REPEATABLE_ENTITY_GROUP = "deleteRepeatableEntityGroup"
public let API_END_EXCUTE_DDC_SCRIPT = "executeDDCScript"
public let API_END_SAVE_TEMPLATE_INSTANCE = "saveTemplateInstance"
public let API_END_RESET_TEMPLATE_INSTANCE = "resetTemplateInstance"
public let API_END_REVOKE_BASE_ENTITY = "revokeBaseEntity"



// All NSUSERDEFAULT key name
// Token Nsuserdefault key name
public let STORED_TOKEN_KEYNAME = "tokenkey"
//UserId Nsuserdefault key name
public let UserId = "UserId"
//UserName Nsuserdefault key name
public let USERNAME = "USERNAME"

public let LOGIN_DATA = "loginData"


// Loading Error display messages
public let Loading = "Loading.."
public let INVALID_LOGIN_ERROR = "Username or Password cannot be empty."

// Key Board Properties
let KEYBOARD_ANIMATION_DURATION: CGFloat = 0.3
let MINIMUM_SCROLL_FRACTION: CGFloat = 0.2
let MAXIMUM_SCROLL_FRACTION: CGFloat = 0.8
let PORTRAIT_KEYBOARD_HEIGHT: CGFloat = 216
let LANDSCAPE_KEYBOARD_HEIGHT: CGFloat = 162
var animatedDistance: CGFloat = 0.0

// Class View Controller Identifier
let MEMORABLE_VIEWCONTROLLER_IDENTIFIER = "memorablekeyverify"

// All TEXTFIELD Placeholders
let LOGIN_USERNAME_TEXTFIELD = "Username"
let LOGIN_PASSWORD_TEXTFIELD = "Password"
let REGISTERED_MOBILE_NUMBER_PLACEHOLDER = "Registered mobile number.."
let REGISTERED_EMAILID_PLACEHOLDER = "Registered email.."
//User Account Status Types 1 IS PENDING
let PENDING_STATUS = 1

//Aplication Title
let APPLICATION_TITLE = "DDC"

// API response  parameter key
let API_SUCCESS_RESPONSE_KEY = "Data"
let API_FAILED_RESPONSE_KEY = "Message"

// API reponse error code messages
public let API_ERROR_CODE_DEFAULT = "Something went wrong please try again."
public let API_ERROR_CODE_200 = "API SUCCESS"
public let API_ERROR_CODE_404 = "Resource not found"
public let API_ERROR_CODE_401 = "You are unauthorised to access this section."
public let API_ERROR_CODE_400 = "Client sent a Bad Request."
public let API_ERROR_CODE_500 = "Internal Server error please try again in sometime"
public let ERROR_MESSAGE_MISSING_MEMMORABLE_KEY = "Please type your key1 and key2"
public let ERROR_MISSING_OR_INVALID_EMAILID = "Please provide valid email ID"

//MARK: Colors
public let BLUSH = UIColor(red: 241.0 / 255.0, green: 184.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
public let TOMATO = UIColor(red: 240.0 / 255.0, green: 89.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
public let BROWNISH_GREY_TWO = UIColor(white: 100.0 / 255.0, alpha: 1.0)
public let MEDIUM_GREY = UIColor(red: 101.0 / 255.0, green: 101.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
public let PURPLE = UIColor(red: 105.0 / 255.0, green: 46.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
public let ORANGE = UIColor(red: 240.0 / 255.0, green: 89.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
public let RED = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
public let WARM_GREY = UIColor(white: 145.0 / 255.0, alpha: 1.0)
public let GREYISH_BROWN = UIColor(white: 88.0 / 255.0, alpha: 1.0)
public let OFF_WHITE = UIColor(red: 1.0, green: 243.0 / 255.0, blue: 227.0 / 255.0, alpha: 1.0)
public let WHITE_THREE = UIColor(white: 239.0 / 255.0, alpha: 1.0)
public let BROWNISH_ORANGE = UIColor(red: 218.0 / 255.0, green: 144.0 / 255.0, blue: 24.0 / 255.0, alpha: 0.6)
public let FADED_BLUE = UIColor(red: 97.0 / 255.0, green: 144.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)

//Temperory Hardcoded token
let TEMP_TOKEN_KEY = "Authorization"

// UAT
let TEMP_TOKEN_VALUE = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhcHBOYW1lIjoiY292aWRfc2FmZWNoZWNrX2Nsb3VkIiwiaWQiOiI2MmVjMzE4YTFlNjZmMTQyZjg0N2VhMDkiLCJpYXQiOjE2NTk2NDYzNDZ9.Jyu7J6G0TlCo_i_7KAZAhpJDALA-yHYG-0kp_WaJoWA"




// MARK: Error Codes And Strings
public let ERROR_MESSAGE_DEFAULT = "Something went wrong. Please try again."
public let SUCCESS_CODE_200 = 200
public let SUCCESS_MESSAGE_FOR_200 = "Response was successful"
public let ERROR_CODE_400 = 400
public let ERROR_MESSAGE_FOR_400 = "Bad Request."
public let ERROR_CODE_401 = 401
public let ERROR_MESSAGE_FOR_401 = "Invalid user login credentials."
public let ERROR_CODE_500 = 500
public let ERROR_MESSAGE_FOR_500 = "Internal Server Error. Please try again."
public let ERROR_CODE_503 = 503
public let ERROR_MESSAGE_FOR_503 = "Internal Server Error. Please try again."




