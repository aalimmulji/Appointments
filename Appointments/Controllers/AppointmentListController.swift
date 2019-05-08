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
    var student = Student()
    let db = Firestore.firestore()
    var appointments : [Appointment] = []
    var documents : [DocumentSnapshot] = []
    private var listerner1: ListenerRegistration?
    
    let dateFormatter = DateFormatter()
    
    
    var sidebarView: SideBarView!
    var blackScreen: UIView!
    var maxBlackViewAlpha: CGFloat = 0.5
    
    var menuOpen = false
    
    
    
    @IBOutlet weak var appointmentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMenuBar()
        
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        
        appointmentListTableView.register(UINib(nibName: "AppointmentCell", bundle: nil), forCellReuseIdentifier: "AppointmentCell")
        appointmentListTableView.rowHeight = 95
        appointmentListTableView.separatorStyle = .singleLine
        
        //MARK:- Observe Query: Get Appointment list
        observeQuery()
    }
    
    func createMenuBar() {
        
        
        //Create Menu Bar
        sidebarView = SideBarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.user = student
        sidebarView.delegate = self
        
        // sidebarView.delegate = self
        self.view.isUserInteractionEnabled=true
        
        sidebarView.layer.zPosition = 100
        
        blackScreen = UIView(frame: self.view.frame)
        blackScreen.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackScreen.isHidden = true
        self.navigationController?.view.addSubview(blackScreen)
        self.navigationController?.view.addSubview(sidebarView)
        blackScreen.layer.zPosition = 99
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(blackScreenTapAction(sender:)))
        blackScreen.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        
        blackScreen.isHidden = false
        self.blackScreen.frame = CGRect(x: self.sidebarView.frame.width, y: 0, width: self.view.frame.width-self.sidebarView.frame.width, height: self.view.bounds.height+100)
        self.blackScreen.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.sidebarView.frame = CGRect(x: 0, y: 0, width: 250, height: self.sidebarView.frame.height)
            self.blackScreen.alpha = 1
        }) { (complete) in
            
        }
    }
    
    @objc func blackScreenTapAction(sender: UITapGestureRecognizer){
        
        print("Black Screen tapped:")
        blackScreen.isHidden = true
        blackScreen.frame = self.view.bounds
        blackScreen.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.sidebarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
            self.blackScreen.alpha = 0
        }
    }

    
    

    func observeQuery() {
        
        appointments.removeAll()
        
        listerner1 = db.collection("appointments").whereField("studentUsername", isEqualTo: "amulji").order(by: "startTime", descending: false).addSnapshotListener({ (snapshot, error) in
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
            print("Documents: ", self.documents)
                self.appointmentListTableView.reloadData()
            })
    }
    
    //MARK:- Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAppointmentView" {
            guard let indexPath = appointmentListTableView.indexPathForSelectedRow else {
                return }
            if let destinationVC = segue.destination as? AppointmentViewController {
                destinationVC.appointment = appointments[indexPath.row]
                destinationVC.documentSnapshot = documents[indexPath.row]
            }
        }
    }


   
}

extension AppointmentListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return appointments.count
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentCell
    
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        cell.timeslotLabel.text = "\(dateFormatter.string(from: appointments[indexPath.row].startTime)) - \(dateFormatter.string(from: appointments[indexPath.row].endTime))"
        cell.professorNameLabel.text = appointments[indexPath.row].profName
        cell.descriptionLabel.text = appointments[indexPath.row].description
        cell.statusLabel.text = appointments[indexPath.row].status
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToAppointmentView", sender: self)
        appointmentListTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AppointmentListController : SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        
    }
}
