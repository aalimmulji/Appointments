//
//  NewScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/13/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

protocol NewScheduleDelegate {
    func newScheduleAdded(timeSlot: String, type: String, row: Int)
}

class NewScheduleController: UIViewController {

    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var typeTextField: UITextField!
    private var startTimePicker : UIDatePicker?
    private var endTimePicker : UIDatePicker?
    
    var previousTimeSlot = ""
    var previousType = ""
    var rowSelected = -1
    var delegate : NewScheduleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if previousTimeSlot != "" {
            var split = previousTimeSlot.split(separator: "-")
            startTimeTextField.text = String(split[0])
            endTimeTextField.text = String(split[1])
            typeTextField.text = previousType
        } else {
            let date = Date()
            var formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeZone = TimeZone.ReferenceType.default
            formatter.timeStyle = .none
            formatter.dateFormat = "HH:mm"
            
            startTimeTextField.text = formatter.string(from: date)
            endTimeTextField.text = formatter.string(from: date)
        }
        
        
        startTimePicker = UIDatePicker()
        startTimePicker?.datePickerMode = .time
        startTimePicker?.addTarget(self, action: #selector(NewScheduleController.startTimeChanged(datePicker:)), for: .valueChanged)
        
        
        endTimePicker = UIDatePicker()
        endTimePicker?.datePickerMode = .time
        endTimePicker?.addTarget(self, action: #selector(NewScheduleController.endTimeChanged(datePicker:)), for: .valueChanged)
        
        
        startTimeTextField.inputView = startTimePicker
        endTimeTextField.inputView = endTimePicker

        createToolBar()
       
    }
    
    
    func createToolBar() {
        let toolbar1 = UIToolbar()
        
        toolbar1.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewScheduleController.doneButton))
        toolbar1.setItems([doneButton], animated: false)
        startTimeTextField.inputAccessoryView = toolbar1
        endTimeTextField?.inputAccessoryView = toolbar1
        toolbar1.isUserInteractionEnabled = true
        
    }
    
    @objc func doneButton   () {
        view.endEditing(true)
    }
    
    
    
    @objc func startTimeChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        startTimeTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func endTimeChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        endTimeTextField.text = dateFormatter.string(from: datePicker.date)
    }
 
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if typeTextField.text! != "" {
        delegate?.newScheduleAdded(timeSlot: "\(startTimeTextField.text!)-\(endTimeTextField.text!)", type: typeTextField.text!, row: rowSelected)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
