//
//  ViewController.swift
//  Example
//
//  Created by Ambu Sangoli on 7/20/22.
//

import UIKit
import DDCFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DDCInitiate.openViewController(uri: "http://chdi.montefiore.org/patientInfo", author: "System", context: "test")
    }


}

