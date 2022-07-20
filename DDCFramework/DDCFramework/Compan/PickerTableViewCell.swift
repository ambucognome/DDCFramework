//
//  PickerTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/24/22.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var uriLbl: UILabel!

    var valuePicker = UIPickerView()
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
    
    var values = [String]()
    
    func setupPickerCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99") {
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.parentEntityGroupId = parentEntityGroupId

//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
        self.textField.text = dataa?.value?.value as? String
        
        if let entity = dataa {
            let minValue = Int(entity.settings?.min ?? 0)
            let maxValue = Int(entity.settings?.max ?? 0) 
            let array = (minValue...maxValue).map { $0 }
            for i in array {
                self.values.append(String(i))
            }
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPickerView))
        toolbar.setItems([doneBtn,spaceButton,cancelButton], animated: false)
        textField.inputAccessoryView = toolbar
        textField.inputView = valuePicker
        valuePicker.delegate = self
        valuePicker.dataSource = self
    }
    
    @objc func done(){
        self.endEditing(true)
//        RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: self.textField.text!)
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: self.textField.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId)
    }
    
    @objc func cancelPickerView(){
        self.endEditing(true)
    }
}


extension PickerTableViewCell : UIPickerViewDelegate,UIPickerViewDataSource  {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return values.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if row == 0{
                if (textField.text!.isEmpty){
                self.textField.text = self.values[row]
                }
            }
            return values[row]
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.textField.text = self.values[row]
      
    }
    
}
