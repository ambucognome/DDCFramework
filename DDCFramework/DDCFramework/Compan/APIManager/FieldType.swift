//
//  FieldType.swift
//  Cognome
//
//  Created by ambu sangoli.
//

import Foundation
import UIKit

enum FieldType: String {
    case textFieldEntity = "TextEntryEntity" // Textfield
    case enumerationEntity = "EnumerationEntity" // EnumerationEntity
    case messageEntity = "MessageEntity" // EnumerationEntity
    case entityGroupRepeatable = "EntityGroupRepeatable"
    case calculatedEntity = "CalculatedEntity"
    
}
enum EnumerationEntityFieldType: String {
    case dropDownField = "dropdown" // dropdown
    case radioButton = "radiobutton" // radiobutton
    case checkBox = "checkbox" // checkbox
    case noMatchEntity = "noMatchEntity" // checkbox
}

enum TextEntryEntityFieldType: String {
    case textareaField = "textarea" // dropdown
    case lineeditField = "lineedit" // lineedit
    case datePicker = "datepicker" // datepicker
    case noMatchEntity = "noMatchEntity" // checkbox
    case timePicker = "timepicker"
    case picker = "spinbox"
    case slider = "slider"
}

enum MessageEntityFieldType: String {
    case messageField = "message" // message
    case noMatchEntity = "noMatchEntity" // checkbox
}

enum EntityGroupRepeatableFieldType: String {
    case inLineRepeatableGroup = "inlinerepeatablegroup"
    case noMatchEntity = "noMatchEntity"
}

enum CalculatedEntityFieldType: String {
    case calculatedField = "calculated"
    case noMatchEntity = "noMatchEntity"
}

class ComponentUtils : NSObject {
    
    class func getFieldType(fieldData:Entity) -> FieldType {
        if let fieldTypeIs = fieldData.type {
            if fieldTypeIs == .textEntryEntity {
                return .textFieldEntity
            }
            if fieldTypeIs == .enumerationEntity {
                return .enumerationEntity
            }
            if fieldTypeIs == .messageEntity {
                return .messageEntity
            }
            if fieldTypeIs == .entityGroupRepeatable {
                return .entityGroupRepeatable
            }
            if fieldTypeIs == .calculatedEntity {
                return .calculatedEntity
            }
        }
        return .textFieldEntity
    }
    
    class func getEnumerationEntityFieldType(fieldData:Entity) -> EnumerationEntityFieldType {
        if let fieldTypeIs = fieldData.guiControlType {
            if fieldTypeIs == "dropdown" {
                return .dropDownField
            }
            else if fieldTypeIs == "radiobutton" {
                return .radioButton
            }
            else if fieldTypeIs == "checkbox" {
                return .checkBox
            }
        }
        return .noMatchEntity
    }
    
    class func getTextEntryEntityFieldType(fieldData:Entity) -> TextEntryEntityFieldType {
        if let fieldTypeIs = fieldData.guiControlType {
            if fieldTypeIs == "lineedit" {
                return .lineeditField
            }
            else if fieldTypeIs == "textarea" {
                return .textareaField
            }
            else if fieldTypeIs == "datepicker" {
                return .datePicker
            } else if fieldTypeIs == "timepicker" {
                return .timePicker
            } else if fieldTypeIs == "spinbox" {
                return .picker
            } else if fieldTypeIs == "slider" {
                return .slider
            }
        }
        return .noMatchEntity
    }
    
    class func getMeesageEntityFieldType(fieldData:Entity) ->  MessageEntityFieldType {
        if let fieldTypeIs = fieldData.guiControlType {
            if fieldTypeIs == "message" {
                return .messageField
            }
        }
        return .noMatchEntity
    }
    
    class func getEntityGroupRepeatableFieldType(fieldData:Entity) ->  EntityGroupRepeatableFieldType {
        if let fieldTypeIs = fieldData.guiControlType {
            if fieldTypeIs == "inlinerepeatablegroup" {
                return .inLineRepeatableGroup
            }
        }
        return .noMatchEntity
    }
    
    class func getCalculatedFieldType(fieldData:Entity) ->  CalculatedEntityFieldType {
        if let fieldTypeIs = fieldData.guiControlType {
            if fieldTypeIs == "calculated" {
                return .calculatedField
            }
        }
        return .noMatchEntity
    }
}




