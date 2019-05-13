//
//  UpdateScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class UpdateScheduleController: UIViewController {

    
    var scheduleForDay = [String: Any]()
    var isAvailableToday = "isAvailableToday"
    var allSchedulesForSelectedDay = [Schedule]()
    
    @IBOutlet weak var scheduleListTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scheduleListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
}
