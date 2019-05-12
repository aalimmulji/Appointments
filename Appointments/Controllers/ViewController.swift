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
    
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    
    let dateFormatter = DateFormatter()
    
    var pendingStatusBackgroundColor = UIColor(colorWithHexValue: 0x65DBBD)
    var pendingStatusTextColor = UIColor(colorWithHexValue: 0x0F4352)
    var pendingStatusColor = UIColor(colorWithHexValue: 0x555555)
    
    //    var approvedStatusBackgroundColor = UIColor(colorWithHexValue: 0x)
    //    var approvedStatusTextColor = UIColor(colorWithHexValue: 0x)
    //    var approvedStatusColor = UIColor(colorWithHexValue: 0x)
    //
    //    var rejectedStatusBackgroundColor = UIColor(colorWithHexValue: 0x)
    //    var rejectedStatusTextColor = UIColor(colorWithHexValue: 0x)
    //    var rejectedStatusColor = UIColor(colorWithHexValue: 0x)
    
    
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
        topNavigationBar.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        topNavigationBar.backBarButtonItem?.tintColor = UIColor.white
        appointmentsListTableView.delegate = self
        appointmentsListTableView.dataSource = self
        
        appointmentsListTableView.register(UINib(nibName: "AppointmentNewCell", bundle: nil), forCellReuseIdentifier: "AppointmentNewCell")
        appointmentsListTableView.rowHeight = 115
        appointmentsListTableView.separatorStyle = .none
        
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
        if segue.identifier == "goToAppointmentView" {
            guard let indexPath = appointmentsListTableView.indexPathForSelectedRow else {
                return }
            if let destinationVC = segue.destination as? AppointmentViewController {
                destinationVC.appointment = filteredAppointments[indexPath.row]
                destinationVC.userType = userType
                destinationVC.documentSnapshot = documents[indexPath.row]
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
        let cell = appointmentsListTableView.dequeueReusableCell(withIdentifier: "AppointmentNewCell", for: indexPath) as! AppointmentNewCell
        
       
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        cell.appointmentDateTimeLabel.text = "\(dateFormatter.string(from: filteredAppointments[indexPath.row].startTime))"
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.appointmentDateTimeLabel.text = "\(cell.appointmentDateTimeLabel.text!) at \(dateFormatter.string(from: filteredAppointments[indexPath.row].startTime))"
        
        cell.professorNameLabel.text = filteredAppointments[indexPath.row].profName
        cell.statusLabel.text = filteredAppointments[indexPath.row].status.uppercased()
        
        cell.appointmentDateTimeLabel.textColor = pendingStatusTextColor
        cell.professorNameLabel.textColor = pendingStatusTextColor
        cell.viewBlock.backgroundColor = pendingStatusBackgroundColor
        cell.statusLabel.textColor = pendingStatusColor
        cell.profPictureImageView.image = UIImage(named: "profile_icon")
        cell.profPictureImageView.contentMode = .scaleAspectFill
        let profPictureStorageRef = Storage.storage().reference().child("professor/\(filteredAppointments[indexPath.row].profId)")
        profPictureStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading the image: \(error)")
            } else {
                let image = UIImage(data: data!)
                cell.profPictureImageView.image = image
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAppointmentView", sender: self)
        appointmentsListTableView.deselectRow(at: indexPath, animated: true)
    }
}

