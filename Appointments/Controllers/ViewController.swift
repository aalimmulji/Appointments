//
//  ViewController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/2/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

class ViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var appointmentsListTableView: UITableView!
    
    
    //MARK:- Global Variables
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
   //let db = Firestore.firestore()
    var appointments : [Appointment] = []
    var filteredAppointments : [Appointment] = []
    var documents : [DocumentSnapshot] = []
    
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // FirebaseApp.configure()
        calendar.scrollDirection = .horizontal
        
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
//        calendar.dataSource = self
//        calendar.delegate = self
//        
//        calendar.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(calendar)
//        
//        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        calendar.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        self.calendar = calendar
        
        appointmentsListTableView.delegate = self
        appointmentsListTableView.dataSource = self
        
        appointmentsListTableView.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        appointmentsListTableView.rowHeight = 95
        appointmentsListTableView.separatorStyle = .singleLine
        
        filterAppointments(forDate: Date())
        
    }
    
    func filterAppointments(forDate date: Date) {
        filteredAppointments = appointments.filter({ (Appointment) -> Bool in
            let todayStartDate = date
            
            let todayEndDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
            let appointmentDateString = Appointment.date
            //            dateFormatter.dateFormat = "yyyy-mm-dd"
            //            guard let appointmentDate = dateFormatter.date(from: appointmentDateString) else {
            //                return false }
            //
            if Appointment.startTime.compare(todayStartDate) == .orderedDescending && Appointment.startTime.compare(todayEndDate) == .orderedAscending {
                return true
            } else {
                return false
            }
        })
        self.appointmentsListTableView.reloadData()
    }
    
    @IBAction func weekMode(_ sender: Any) {
            
        calendar.scope = .week
    }
    
    @IBAction func monthMode(_ sender: Any){
        calendar.scope = .month
    }
    @IBAction func dayMode(_ sender: Any) {
        
        let dayViewController = CalendarKitMainController()
        performSegue(withIdentifier: "goToCalendarKit", sender: self)
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToProfessorList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfessorList" {
            if let destinationVC = segue.destination as? ProfessorListController {
                destinationVC.userType = userType
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
            }
        }
    }
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        filterAppointments(forDate: date)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAppointments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentsListTableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        cell.timeslotLabel.text = "\(dateFormatter.string(from: filteredAppointments[indexPath.row].startTime)) - \(dateFormatter.string(from: filteredAppointments[indexPath.row].endTime))"
        cell.professorNameLabel.text = filteredAppointments[indexPath.row].profName
        cell.descriptionLabel.text = filteredAppointments[indexPath.row].description
        cell.statusLabel.text = filteredAppointments[indexPath.row].status
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

