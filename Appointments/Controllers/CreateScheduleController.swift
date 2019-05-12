//
//  CreateScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class CreateScheduleController: UIViewController {
    
    
    @IBOutlet weak var weekDaysTableView: UITableView!
    
    var weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekDaysTableView.delegate = self
        weekDaysTableView.dataSource = self
        
        weekDaysTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        weekDaysTableView.rowHeight = 45
        weekDaysTableView.isScrollEnabled = false
        weekDaysTableView.separatorStyle = .none
        
    }
    

}

extension CreateScheduleController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekDaysTableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
        cell.profileRowTitleLabel.text = weekDays[indexPath.row]
        cell.profileRowValueLabel.text = ""
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
