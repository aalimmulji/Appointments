//
//  AppointmentListController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/18/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class AppointmentListController: UIViewController {

    
    //      let db = Firestore.firestore()
    let appointments = [Appointment]()
    
    
    @IBOutlet weak var appointmentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        
        appointmentListTableView.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        appointmentListTableView.rowHeight = 95
        appointmentListTableView.separatorStyle = .singleLine
    }
    

   
}

extension AppointmentListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return appointments.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAppointmentView", sender: self)
    }
}
