//
//  DynamicTemplateViewController.swift
//  Compan
//
//  Created by Ambu Sangoli on 10/05/22.
//

import UIKit
import SwiftUI

//Model declared globally
var ddcModel : DDCFormModel?


class DynamicTemplateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "DefaultCell")
        tableView.dataSource = self
        
        //Register cell for using in tableview
        tableView.register(UINib(nibName: "TextfieldComponent", bundle: nil), forCellReuseIdentifier: "TextfieldComponent")
        tableView.register(UINib(nibName: "DropDownTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownTableViewCell")
        tableView.register(UINib(nibName: "RadioButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "RadioButtonTableViewCell")
        tableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "DatePickerTableViewCell")
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTableViewCell")
        tableView.register(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "TimePickerTableViewCell")
        tableView.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
        tableView.register(UINib(nibName: "SliderTableViewCell", bundle: nil), forCellReuseIdentifier: "SliderTableViewCell")
        tableView.register(UINib(nibName: "RepeatableTableViewCell", bundle: nil), forCellReuseIdentifier: "RepeatableTableViewCell")

        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        self.hideKeyboardWhenTappedAround()
        self.tableView.remembersLastFocusedIndexPath = true

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        self.addObservers()
    }
    deinit {
        removeObservers()
    }
    

    func setUpData() {
        
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationAction),
            name: NSNotification.Name(rawValue: "ReloadTable") ,
            object: nil
        )
    }
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue:"ReloadTable"), object: nil)

    }
    
    @objc func notificationAction() {
           // self.tableView.reloadData()
        UIView.setAnimationsEnabled(false)
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
              //  self.tableView.beginUpdates()
             //   self.tableView.endUpdates()
            }
          }

    

// MARK: - UITableViewDataSource
func numberOfSections(in tableView: UITableView) -> Int {
//    return (ddcModel?.template?.entities?.count)!
    return (ddcModel?.template?.sortedArray?.count)!
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if ddcModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || ddcModel?.template?.sortedArray?[section].value.type == .entityGroup {
        return ddcModel?.template?.sortedArray?[section].value.sortedEntityGroupsArray?.count ?? 0
    }
    return 1
}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        view.backgroundColor = UIColor(red: 168.0/255.0, green: 219.0/255.0, blue: 205.0/255.0, alpha: 1)
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
        titleLabel.textColor = .white
        view.addSubview(titleLabel)
        if ddcModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || ddcModel?.template?.sortedArray?[section].value.type == .entityGroup {
            titleLabel.text = ddcModel?.template?.sortedArray?[section].value.title ?? ""
        } else {
            if section == 0 {
            titleLabel.text =  ddcModel?.template?.title
            }
        }
        if ddcModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || ddcModel?.template?.sortedArray?[section].value.type == .entityGroup {

            let button = UIButton()
                button.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                button.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
                button.tag = section
                view.addSubview(button)


            if ddcModel?.template?.entities?.count != 1 {
                let button = UIButton()
                button.setBackgroundImage(UIImage.remove.withTintColor(.red), for: .normal)
                button.frame = CGRect(x: view.frame.maxX - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                button.addTarget(self, action: #selector(self.removeButton(_:)), for: .touchUpInside)
                button.tag = section
                view.addSubview(button)

                let addbutton = UIButton()
                addbutton.setBackgroundImage(UIImage.add.withTintColor(.blue), for: .normal)
                addbutton.frame = CGRect(x: button.frame.origin.x - 40, y: view.frame.midY - 17.5, width: 35, height: 35)
                addbutton.addTarget(self, action: #selector(self.addButton(_:)), for: .touchUpInside)
                addbutton.tag = section
                view.addSubview(addbutton)
            }


        }
        return view
    }
    
    @objc func addButton(_ sender: UIButton) {
        print(sender.tag)
//        let data = ddcModel?.template?.entities![sender.tag]
        
//        let repeated  = Entity(type: data?.type, title: data?.title, active: data?.active, order: data?.order, guiControlType: data?.guiControlType, id: data?.id, value: data?.value, oldValue: data?.oldValue, lastUpdatedBy: data?.lastUpdatedBy, lastUpdatedDate: data?.lastUpdatedDate, uri: data?.uri, valueSetRef: data?.valueSetRef, settings: data?.settings, entityGroups: data?.entityGroups, isRepeated: true)
//
//        ddcModel?.template?.entities?.insert(repeated, at: sender.tag + 1)
//        self.tableView.reloadData()
//        self.tableView.scrollToRow(at: IndexPath(row: 0, section: sender.tag + 1), at: .middle, animated: true)
    }
    
    @objc func removeButton(_ sender: UIButton) {
        print(sender.tag)
//        ddcModel?.template?.entities?.remove(at: sender.tag)
//        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ddcModel?.template?.sortedArray?[section].value.type == .entityGroupRepeatable || ddcModel?.template?.sortedArray?[section].value.type == .entityGroup {
            return 0
        } else {
        if section == 0 {
            return 50
        }
        }
        return 0
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var data : Entity?
        if ddcModel?.template?.sortedArray![indexPath.section].value.type == .entityGroupRepeatable {
//            data = ddcModel?.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
            return Utilities.shared.calculateGroupHeight(tableView: tableView, entityGroup: (ddcModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray?[indexPath.row].value)!, data: ddcModel!)
        } else {
            data = ddcModel?.template?.sortedArray![indexPath.section].value
        }
        if data!.type == .calculatedEntity {
            return 0
        }
            
        if data!.isHidden {
            return 0
        }
        let enumerationEntityfieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
        let textEntityFieldType = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
        let messageEntityFieldType = ComponentUtils.getMeesageEntityFieldType(fieldData:data!)

        print(textEntityFieldType)
        if enumerationEntityfieldTypeIs == .radioButton {

//        let dropDownSet = ddcModel?.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((data!.valueSetRef)!)}
        let dropDownSet = ddcModel?.valueSet?[(data!.valueSetRef!)]

        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 100

        return CGFloat(dynamicHeightforRadioCell)

      } else  if enumerationEntityfieldTypeIs == .checkBox {

//        let dropDownSet = ddcModel?.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((data!.valueSetRef)!)}
//
          let dropDownSet = ddcModel?.valueSet?[(data!.valueSetRef!)]
        let dynamicHeightforRadioCell = dropDownSet!.count * 50 + 100

            return CGFloat(dynamicHeightforRadioCell)

      } else if enumerationEntityfieldTypeIs == .dropDownField {
          
          return 100//UITableView.automaticDimension

       } else if textEntityFieldType == .textareaField {
        
        return 200//UITableView.automaticDimension
       } else if textEntityFieldType == .datePicker {
           
           return 100//UITableView.automaticDimension
       } else if messageEntityFieldType == .messageField {
           return 220//UITableView.automaticDimension
       } else if textEntityFieldType == .timePicker {
           return 100//UITableView.automaticDimension
       } else if textEntityFieldType == .picker {
           return 100//UITableView.automaticDimension
       } else if textEntityFieldType == .slider {
           return 100//UITableView.automaticDimension
       }

        return 100
}
    
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

let cellIdentifier = "DefaultCell"

var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
if cell == nil {
    cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
}
//if indexPath.section == 0 {
  
    if ddcModel != nil {
        var data : Entity?
        if ddcModel?.template?.sortedArray![indexPath.section].value.type == .entityGroupRepeatable {
//            data = ddcModel?.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatableTableViewCell", for: indexPath) as! RepeatableTableViewCell
            cell.setupRepeatableGroupCell(entityGroup: (ddcModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row].value)!, data:ddcModel!, parentEntityGroupId: (ddcModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row].value.uniqueId)!)
            
            cell.setupHeaderView(entityGroup: (ddcModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray![indexPath.row])!.value, groupCount: ddcModel?.template?.sortedArray![indexPath.section].value.sortedEntityGroupsArray!.count ?? 0, sectionIndex: 0)
            return cell
        } else {
            data = ddcModel?.template?.sortedArray![indexPath.section].value
        }
        if data?.type  == .textEntryEntity {
            let fieldTypeIs = ComponentUtils.getTextEntryEntityFieldType(fieldData:data!)
            if fieldTypeIs == .lineeditField {

                let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldComponent", for: indexPath) as! TextfieldComponent
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.textField.setBottomBorder()
                cell.textField.placeholder = "Enter " + (data?.uri)!
                cell.setUpTextFieldCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")
                return cell

        } else if fieldTypeIs == .textareaField {

                let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as! TextViewTableViewCell
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

            cell.setUpTextViewAreaCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")

                return cell

        } else if fieldTypeIs == .datePicker {

                   let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
//                   cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                       [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpDatePickerCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")

                   return cell

        } else if fieldTypeIs == .timePicker {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TimePickerTableViewCell", for: indexPath) as! TimePickerTableViewCell
//            cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                           [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpTimePickerCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")
            return cell

        } else if fieldTypeIs == .picker {

            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
//            cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                           [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setupPickerCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")
            return cell

        }
            else if fieldTypeIs == .slider {

               let cell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell", for: indexPath) as! SliderTableViewCell
//               cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                              [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.setupSliderCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")
               return cell

           }


        } else if data?.type  == .enumerationEntity {
            let fieldTypeIs = ComponentUtils.getEnumerationEntityFieldType(fieldData:data!)
            if fieldTypeIs == .dropDownField {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell", for: indexPath) as! DropDownTableViewCell
              //  cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
                //    [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

                cell.setUpDropDownCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")
                return cell
        } else if fieldTypeIs == .radioButton {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RadioButtonTableViewCell", for: indexPath) as! RadioButtonTableViewCell
              // cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
             //      [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString

            cell.setUpRadioCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")

                return cell
        } else if fieldTypeIs == .checkBox {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as! CheckBoxTableViewCell
//                cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                    [.underlineStyle: NSUnderlineStyle.single.rawValue])
            cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
            cell.setUpCheckBoxCell(data: ddcModel!, entity: data!,indexPath: indexPath, entityGroupId: ddcModel?.template?.uniqueId ?? "")

                 return cell
        }
        }
            else if data?.type  == .messageEntity {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
//               cell.uriLbl.attributedText = NSAttributedString(string: (data?.uri)!, attributes:
//                   [.underlineStyle: NSUnderlineStyle.single.rawValue])
                cell.uriLbl.attributedText = data?.title?.htmlToAttributedString
                cell.setUpMessageCell(data: ddcModel!, entity: data!,indexPath: indexPath,tableView: self.tableView)

                return cell
        }


//    }
}

    return cell!
}

// MARK: - UITableViewDelegate
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

}

    /// Title height
    
    func heightForTitle(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
}
