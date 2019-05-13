//
//  NewAppointmentController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/14/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase
import CoreGraphics

class NewAppointmentController: UIViewController, UITextViewDelegate {

    
    //MARK:- IBOutlets
    
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var timeslotTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView! {
        didSet {
            descriptionTextView.textColor = UIColor.lightGray
            descriptionTextView.text = "Description"
        }
    }
    
    @IBOutlet weak var bookBarButtonItem: UIBarButtonItem!
    
    //MARK:- Global Variables
    var durationOptions = ["5 mins", "10 mins", "15 mins", "30 mins", "45 mins", "60 mins"]
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
    var professor = Professor()
    var db = Firestore.firestore()
    private var listerner1: ListenerRegistration?, listerner2: ListenerRegistration?
    var appointments : [Appointment] = []
    var documents : [DocumentSnapshot] = []
    var selectedDate : Date = Date()
    var selectedDayScheduleTimeslots = [String]()
    var timeslots : [[String : Date]] = [[String: Date]]()

    var formatter = DateFormatter()
    let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPicker()
        createToolBar()
        
        
        descriptionTextView.delegate = self
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.ReferenceType.default
        observeQuery(forDate: formatter.string(from: selectedDate))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        descriptionTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.isFirstResponder {
            
            if descriptionTextView.textColor! == UIColor.lightGray {
                descriptionTextView.textColor = UIColor.black
                descriptionTextView.text = ""
            }
        }
    }
    
    func createPicker() {
        
        picker.delegate = self
        picker.selectedRow(inComponent: 0)
        
        durationTextField.inputView = picker
        durationTextField.tintColor = .clear
        
        timeslotTextField.inputView = picker
        timeslotTextField.tintColor = .clear
    }
    
    func createToolBar() {
        let toolbar1 = UIToolbar()
        let toolbar2 = UIToolbar()
        
        toolbar1.sizeToFit()
        toolbar2.sizeToFit()
        
        let doneButtonForDuration = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewAppointmentController.doneButtonForDuration))
        let doneButtonForTimeslot = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewAppointmentController.doneButtonForTimeslot))
        toolbar1.setItems([doneButtonForDuration], animated: false)
        durationTextField.inputAccessoryView = toolbar1
        toolbar1.isUserInteractionEnabled = true
        
        toolbar2.setItems([doneButtonForTimeslot], animated: false)
        timeslotTextField.inputAccessoryView = toolbar2
        toolbar2.isUserInteractionEnabled = true
    }
    
    @objc func doneButtonForDuration() {
        view.endEditing(true)
        createTimeslots()
    }
    @objc func doneButtonForTimeslot() {
        view.endEditing(true)
    }
    
    func createTimeslots() {
    
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .none
//        dateFormatter.dateFormat = "HH:mm"
        
        
//        var date = Date()
//        var currentTime = date.format(with: "HH:mm", timeZone: TimeZone.ReferenceType.default)
//
//        print("Current Time:", currentTime)
//
//        var number = 43
//        var round = (number + 15)/15 * 15
//        print(round)
        
        
        print("Prof Schedule:, ", selectedDayScheduleTimeslots)
        
        var startingHours = [Date]()
        var endingHours = [Date]()
        for timeString in selectedDayScheduleTimeslots {
            
            let startTimeString = String(timeString.split(separator: "-")[0])
            
            let startDate = Calendar.current.date(bySettingHour: Int(startTimeString.split(separator: ":")[0]) ?? 0, minute: Int(startTimeString.split(separator: ":")[1]) ?? 0, second: 0, of: selectedDate)
            if let startDate = startDate {
                print("StartDate: ", startDate)
                startingHours.append(startDate)
            }
            
            let endTimeString = String(timeString.split(separator: "-")[1])
            
            let endDate = Calendar.current.date(bySettingHour: Int(endTimeString.split(separator: ":")[0]) ?? 0, minute: Int(endTimeString.split(separator: ":")[1]) ?? 0, second: 0, of: selectedDate)
            
            if let endDate = endDate {
                print("End Date: ", endDate)
                endingHours.append(endDate)
            }
        }
        
        startingHours = startingHours.sorted(by: {
            $0.compare($1) == .orderedAscending
        })
        print("StartHours: ", startingHours)
        
        endingHours = endingHours.sorted(by: {
            $0.compare($1) == .orderedDescending
        })
        print("End Hours: ", endingHours)
        
        let duration = Int(durationTextField.text!.split(separator: " ")[0])!
        
        
        checkAvailableTimeslots(startTime: startingHours[0], endTime: endingHours[0], duration: duration)
        
    }
    
    func checkAvailableTimeslots(startTime: Date, endTime: Date, duration: Int) {
        let date = Date()
        let today = Calendar.current.date(byAdding: .minute, value: 15, to: date)
        
        var tempStartDate = startTime
        var tempEndDate = startTime
        timeslots.removeAll()
        
        Calendar.autoupdatingCurrent.dateRange(from: startTime, to: endTime, component: .minute, by: duration).forEach { (date) in
            tempEndDate = date
            
            if today?.compare(tempStartDate) == .orderedAscending || today?.compare(tempStartDate) == .orderedSame {
            
                if !appointments.isEmpty {
                    let thisTimeslotIsAvailable = appointments.allSatisfy({ (Appointment) -> Bool in
                        if (Appointment.startTime.compare(tempStartDate) == .orderedDescending && Appointment.endTime.compare(tempEndDate) == .orderedAscending) ||
                            (Appointment.startTime.compare(tempStartDate) == .orderedAscending && Appointment.endTime.compare(tempStartDate) == .orderedDescending) ||
                            (Appointment.startTime.compare(tempEndDate) == .orderedAscending && Appointment.endTime.compare(tempEndDate) == .orderedDescending) ||
                            (Appointment.startTime.compare(tempStartDate) == .orderedSame && Appointment.endTime.compare(tempStartDate) == .orderedDescending) ||
                            (Appointment.startTime.compare(tempEndDate) == .orderedAscending && Appointment.endTime.compare(tempEndDate) == .orderedSame){
                            return false
                        } else {
                            return true
                        }
                    })
                    
                    if thisTimeslotIsAvailable {
                        let timeslot = [
                            "startDate": tempStartDate,
                            "endDate": tempEndDate]
                        timeslots.append(timeslot)
                    }
                } else if appointments.isEmpty {
                    let timeslot = [
                        "startDate": tempStartDate,
                        "endDate": tempEndDate]
                    timeslots.append(timeslot)
                }
                
            }
            
            tempStartDate = tempEndDate
            
        }
        if timeslots.count > 0 {
            let timeslot = timeslots[0]
            guard let startDate = timeslot["startDate"] as? Date,
                let endDate = timeslot["endDate"] as? Date else { return }
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone.ReferenceType.default
            
            timeslotTextField.text = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
            timeslotTextField.isUserInteractionEnabled = true
            bookBarButtonItem.tintColor = UIColor(colorWithHexValue: 0x57A6A3)
            bookBarButtonItem.isEnabled = true
        } else {
            timeslotTextField.text = "No available timeslots"
            timeslotTextField.isUserInteractionEnabled = false
            bookBarButtonItem.tintColor = UIColor.lightGray
            bookBarButtonItem.isEnabled = false
        }
        self.picker.reloadAllComponents()
        self.view.layoutIfNeeded()
        
    }
    
    func observeQuery(forDate date: String) {
        
        appointments.removeAll()
        
        listerner1 = db.collection("appointments").whereField("profId", isEqualTo: professor.profId)
            .whereField("date", isEqualTo: date).addSnapshotListener({ (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot result: \(error)")
                    return
                }
            
                let models = snapshot.documents.map({ (document) -> Appointment in
                    
                    print("Documents.data(): ", document.data())
                    if let model = Appointment(dictionary: document.data()) {
                        return model
                    } else {
                        print("Unable to initialize \(Appointment.self) with document data \(document.data())")
                        return Appointment()
                    }
                })
                
                self.appointments = models
                print("Appointments: \n", self.appointments)
                self.documents = snapshot.documents
                self.createTimeslots()
            })
    }
    
    
    @IBAction func bookButtonPressed(_ sender: Any) {
        
        
        if descriptionTextView.textColor! != UIColor.lightGray && descriptionTextView.text.count != 0 {
            
            
            let selectedDuration = Int(durationTextField.text!.split(separator: " ")[0])!
            let selectedTimeslotString = timeslotTextField.text!
            
            let description = descriptionTextView.text!
            
            var newAppointment = Appointment()
            
            
            let startDateString = selectedTimeslotString.split(separator: "-")[0]
            
            var startHour = Int(startDateString.split(separator: ":")[0])!
            let startMins = Int(startDateString.split(separator: ":")[1].split(separator: " ")[0])!
            let startPeriod = startDateString.split(separator: ":")[1].split(separator: " ")[1]
            
            if  startPeriod == "PM" && startHour > 12 {
                startHour += 12
            }
            
            let endDateString = selectedTimeslotString.split(separator: "-")[1]
            print("endDateString:\(endDateString)..")
            
            let trimmedEndDateString = endDateString.trimmingCharacters(in: .whitespaces)
            var endHour = Int(trimmedEndDateString.split(separator: ":")[0])!
            let endMins = Int(trimmedEndDateString.split(separator: ":")[1].split(separator: " ")[0])!
            let endPeriod = trimmedEndDateString.split(separator: ":")[1].split(separator: " ")[1]
            
            if  endPeriod == "PM" && startHour > 12  {
                endHour += 12
            }
            
            print("Selected Start Hours: \(startHour) and Mins: \(startMins) and period: \(startPeriod)...")
            print("Selected End Hours: \(endHour) and Mins: \(endMins) and period: \(endPeriod)...")
            
            if let startTime = Calendar.current.date(bySettingHour: startHour, minute: startMins, second: 0, of: selectedDate) {
                newAppointment.startTime = startTime
            }
            if let endTime = Calendar.current.date(bySettingHour: endHour, minute: endMins, second: 0, of: selectedDate) {
                newAppointment.endTime = endTime
            }
            
            if let duration = Int(durationTextField.text!.split(separator: " ")[0]) {
                newAppointment.duration = duration
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.timeZone = TimeZone.ReferenceType.default
            newAppointment.description = descriptionTextView.text
            newAppointment.profId = professor.profId
            newAppointment.profName = "\(professor.firstName) \(professor.lastName)"
            newAppointment.studentUsername = student.username
            newAppointment.studentName = "\(student.firstName) \(student.lastName)"
            newAppointment.status = "pending"
            newAppointment.date = formatter.string(from: selectedDate)
            var newAppDoc = db.collection("appointments").document()
            newAppDoc.setData(newAppointment.dictionary) {
                err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    let alert = UIAlertController(title: "New Appointment Created", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        let sender = PushNotificationSender()
                        sender.sendPushNotification(to: self.professor.fcmToken, title: "New Appointment Request", body: "New appointment request from \(self.student.firstName)")
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Description can't be empty", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))   
            self.present(alert, animated: true, completion: nil)
        }
    }
}


//MARK:- UIPickerView delegate and datasource

extension NewAppointmentController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if durationTextField.isFirstResponder {
            return durationOptions.count
        } else {
            return timeslots.count //change to timeslotOptions count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if durationTextField.isFirstResponder {
            return durationOptions[row]
        } else {
            let timeslot = timeslots[row]
            guard let startDate = timeslot["startDate"] as? Date,
                let endDate = timeslot["endDate"] as? Date else { return nil }
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone.ReferenceType.default
                
            return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if durationTextField.isFirstResponder {
            durationTextField.text = durationOptions[row]
        } else if timeslotTextField.isFirstResponder {
            let timeslot = timeslots[row]
            guard let startDate = timeslot["startDate"] as? Date,
                let endDate = timeslot["endDate"] as? Date else { return }
            
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            formatter.timeZone = TimeZone.ReferenceType.default
            
            timeslotTextField.text = "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
            
        }
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}



