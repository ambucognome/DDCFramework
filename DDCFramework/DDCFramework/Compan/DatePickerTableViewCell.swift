//
//  DatePickerTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 23/05/22.
//

import UIKit
import DatePickerDialog

class DatePickerTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var uriLbl: UILabel!

    let datePicker = DatePickerDialog()
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpDatePickerCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99") {
        self.entityGroupId = entityGroupId
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.entity = entity
        self.parentEntityGroupId = parentEntityGroupId

//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
        
        self.textField.text = dataa?.value?.value as? String ?? ""
    }
    
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)

        datePicker.show("DatePickerDialog",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/YYYY"
                self.textField.text = formatter.string(from: dt)
//                RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: self.textField.text!)
                RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: self.textField.text!, entityGroupId: self.entityGroupId,parentEntityGroupId: self.parentEntityGroupId)

                
            }
        }
    }
    
    //MARK: Textfield Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.textField {
            datePickerTapped()
            return false
        }
        return true
    }
}


