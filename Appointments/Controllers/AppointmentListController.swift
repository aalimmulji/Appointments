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

    //MARK:- IBOutlets
    
    //MARK:- Global Variables
    var user = User()
    let db = Firestore.firestore()
    var appointments : [Appointment] = []
    var documents : [DocumentSnapshot] = []
    private var listerner1: ListenerRegistration?
    
    
    
    @IBOutlet weak var appointmentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        
        appointmentListTableView.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        appointmentListTableView.rowHeight = 95
        appointmentListTableView.separatorStyle = .singleLine
        
        //MARK:- Observe Query: Get Appointment list
        observeQuery()
    }
    

    func observeQuery() {
        
        appointments.removeAll()
        
        listerner1 = db.collection("appointments").whereField("userId", isEqualTo: "u123").order(by: "startTime", descending: false).addSnapshotListener({ (snapshot, error) in
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
            })
    }


   
}

extension AppointmentListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return appointments.count
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAppointmentView", sender: self)
    }
}
