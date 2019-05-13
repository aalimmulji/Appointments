//
//  UpdateScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
protocol updateScheduleForDayDelegate {
    func updateScheduleForDay(schedule: [String: AnyObject], forDay : String)
}

class UpdateScheduleController: UIViewController {

    
    var scheduleForDay = [String: AnyObject]()
    var isAvailableToday = "isAvailableToday"
    var allSchedulesForSelectedDay = [Schedule]()
    var dayFull = ""
    var dayShort = ""
    var selectedIndex = -1
    var delegate : updateScheduleForDayDelegate?
    
    @IBOutlet weak var scheduleListTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scheduleListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = dayFull
        
        addExistingSchedulesToArray()
        
        scheduleListTableView.delegate = self
        scheduleListTableView.dataSource = self
        
        scheduleListTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        scheduleListTableView.rowHeight = 45
        scheduleListTableView.isScrollEnabled = false
        scheduleListTableView.separatorStyle = .none
        scheduleListTableHeightConstraint.constant = CGFloat(allSchedulesForSelectedDay.count * 45)

    }
    
    func addExistingSchedulesToArray() {
        
        if let isAvailableToday = scheduleForDay[isAvailableToday] as? Bool {
            if isAvailableToday {
                if let schedules = scheduleForDay["schedule"] as? [String: Any] {
                    for schedule in schedules {
                        var newSch = Schedule()
                        
                        if let scheduleData = schedule.value as? [String: String] {
                            newSch.timeSlot = scheduleData["timeSlot"] as! String
                            newSch.type = scheduleData["type"] as! String
                        }
                        allSchedulesForSelectedDay.append(newSch)
                    }
                }
            }
        }
    }
    
    @IBAction func addNewSchedulePressed(_ sender: Any) {
//        var timeSlotTextField = UITextField()
//        var typeTextField = UITextField()
//
//        let alert = UIAlertController(title: "Add New Schedule", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            //what will happen once the user clicks the Add Item button on out UIAlert
//
//            if timeSlotTextField.text! != "" && typeTextField.text! != "" {
//                var temp = Schedule()
//                temp.timeSlot = timeSlotTextField.text!
//                temp.type = typeTextField.text!
//                self.allSchedulesForSelectedDay.append(temp)
//                self.scheduleListTableHeightConstraint.constant += 45
//                self.scheduleListTableView.reloadData()
//            }
//
//        }
//
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Enter Time-Slot like (10:30pm - 11:30pm)"
//            timeSlotTextField = alertTextField
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "Enter Type of like (office hours)"
//            typeTextField = alertTextField
//        }
//
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
        
        performSegue(withIdentifier: "addNewSchedule", sender: self)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let isAvailableToday = scheduleForDay[isAvailableToday] as? Bool {
            if !isAvailableToday {
                scheduleForDay["isAvailableToday"] = true as AnyObject
            }
            var tempScheduleDict = [String : AnyObject]()
            for i in 0..<allSchedulesForSelectedDay.count {
                var temp = [
                    "timeSlot" : allSchedulesForSelectedDay[i].timeSlot,
                    "type" : allSchedulesForSelectedDay[i].type
                ]
                tempScheduleDict["\(i)"] = temp as AnyObject
                
            }
            
            scheduleForDay["schedule"] = tempScheduleDict as AnyObject
        }
        delegate?.updateScheduleForDay(schedule: scheduleForDay, forDay: dayShort)
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewSchedule" {
            if let destinationVC = segue.destination as? NewScheduleController {
                destinationVC.delegate = self
                if selectedIndex != -1 {
                    destinationVC.previousTimeSlot = allSchedulesForSelectedDay[selectedIndex].timeSlot
                    destinationVC.previousType = allSchedulesForSelectedDay[selectedIndex].type
                    destinationVC.rowSelected = selectedIndex
                }
                
            }
        }
    }
    
    
    
    
}

extension UpdateScheduleController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSchedulesForSelectedDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleListTableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
        cell.profileRowTitleLabel.text = allSchedulesForSelectedDay[indexPath.row].type
        cell.profileRowValueLabel.text = allSchedulesForSelectedDay[indexPath.row].timeSlot
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "addNewSchedule", sender: self)
        scheduleListTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UpdateScheduleController: NewScheduleDelegate {
    func newScheduleAdded(timeSlot: String, type: String, row: Int) {
        if row == -1 {
            var temp = Schedule()
            temp.timeSlot = timeSlot
            temp.type = type
            self.allSchedulesForSelectedDay.append(temp)
            self.scheduleListTableHeightConstraint.constant += 45
            self.scheduleListTableView.reloadData()
        } else {
            var temp = Schedule()
            temp.timeSlot = timeSlot
            temp.type = type
            self.allSchedulesForSelectedDay[row] = temp
            self.scheduleListTableView.reloadData()
        }
        
    }
}
