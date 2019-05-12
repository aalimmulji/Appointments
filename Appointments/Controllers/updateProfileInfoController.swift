//
//  updateProfileInfoController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

protocol UpdateProfileInfoDelegate {
    func updateProfileInfo(atRow row: Int, withValue value: String)
}

class updateProfileInfoController: UIViewController {
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    
    var selectedRow = -1
    var headerText = ""
    var previousValue = ""
    
    var delegate : UpdateProfileInfoDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTextLabel.text = "Update your \(headerText)"
        valueTextField.placeholder = "Enter your \(headerText)"
        valueTextField.text = previousValue
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        delegate?.updateProfileInfo(atRow: selectedRow, withValue: valueTextField.text!)
        self.navigationController?.popViewController(animated: true)
    }
    

}
