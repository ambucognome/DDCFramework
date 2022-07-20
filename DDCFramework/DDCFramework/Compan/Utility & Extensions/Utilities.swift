//
//  Utilities.swift
//  Cognome
//
//  Created by Ambu Sangoli
//  Copyright © 2022 Cognome. All rights reserved.
//

import UIKit

class Utilities: NSObject {

    static let shared = Utilities()

    // Validation for entered email address
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    //CHeck empty textfield
    func checkEmptyTextFIeld(txtStr:String) -> Bool {
        if (txtStr == "") {
            return false
        } else {
            return true
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    func calculateGroupHeightCell(tableView: UITableView, entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0
        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
        for entity in entityGroup.sortedEntitiesArray ?? [] {

            if entity.value.type == .entityGroupRepeatable || entity.value.type == .entityGroup {
                for group in entity.value.sortedEntityGroupsArray ?? [] {
                    totalHeight += self.getEntityHeigh(entityGroup: group.value, data: data)

                }
            }
        }
        return totalHeight + 50
    }
    
    
    func calculateGroupHeight(tableView: UITableView, entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0
        totalHeight += self.getEntityHeigh(entityGroup: entityGroup, data: data)
        for entity in entityGroup.sortedEntitiesArray ?? [] {

            if entity.value.type == .entityGroupRepeatable || entity.value.type == .entityGroup {
                for group in entity.value.sortedEntityGroupsArray ?? [] {
                    totalHeight += self.getEntityHeigh(entityGroup: group.value, data: data)
                }
            }
        }
        return totalHeight + 50
    }
    
    
    func getEntityHeigh(entityGroup: EntityRepeatableGroup,data: DDCFormModel) -> CGFloat {
        var totalHeight : CGFloat = 0

        for entity in entityGroup.sortedEntitiesArray ?? [] {
            let entityData = entity.value
            if entityData.isHidden {
                totalHeight += 0
            } else if entityData.type == .calculatedEntity {
                totalHeight += 0
            }  else {
            let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:entityData)
            let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:entityData)
            let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:entityData)
           

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

//        let dropDownSet = data.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((entity.valueSetRef)!)}
//
            let dropDownSet = data.valueSet?[(entity.value.valueSetRef!)]

        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 50
//
            totalHeight += CGFloat(dynamicHeightforRadioCell)
//            totalHeight += 100

      } else  if enumerationEntityfieldTypeIs == .checkBox {

//        let dropDownSet = data.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((entity.valueSetRef)!)}
          let dropDownSet = data.valueSet?[(entity.value.valueSetRef!)]

      let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 50
//
          totalHeight += CGFloat(dynamicHeightforRadioCell)

      } else if enumerationEntityfieldTypeIs == .dropDownField {
          
          totalHeight += 100//UITableView.automaticDimension

       } else if textEntityFieldType == .textareaField {
        
           totalHeight += 200//UITableView.automaticDimension
       } else if textEntityFieldType == .datePicker {
           
           totalHeight += 100//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
           totalHeight += 100//UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           totalHeight += 100//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           totalHeight += 100//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           totalHeight += 100//UITableView.automaticDimension
       } else {
           totalHeight += 100
       }
        }
        }
        return totalHeight
        
    }
}
