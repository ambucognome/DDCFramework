//
//  TextfieldComponent.swift.swift
//  Cognome
//
//  Created by ambu sangoli.
//

import UIKit

protocol TextfieldComponentDelegate {

}

class TextfieldComponent: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var floatingTextField: FloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""

    
    func setUpTextFieldCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath,entityGroupId: String,parentEntityGroupId:String = "99") {
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.textField.delegate = self
        self.data = data
        self.indexPath = indexPath
        let dataa : Entity? = entity
        self.parentEntityGroupId = parentEntityGroupId


        self.textField.text = dataa?.value?.value as? String ?? ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print(RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: textField.text!))
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: textField.text!, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId)

    }
    
}

