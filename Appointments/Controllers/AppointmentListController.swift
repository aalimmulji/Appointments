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

    
    //MARK:- Global Variables
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
    let db = Firestore.firestore()
    var appointments : [Appointment] = []
    var pendingAppointments : [Appointment] = []
    var documents : [DocumentSnapshot] = []
    private var listerner1: ListenerRegistration?
    
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    let dateFormatter = DateFormatter()
    
    
    var sidebarView: SideBarView!
    var blackScreen: UIView!
    var maxBlackViewAlpha: CGFloat = 0.5
    
    var menuOpen = false
    
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
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var appointmentListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMenuBar()
        
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        
        appointmentListTableView.register(UINib(nibName: "AppointmentNewCell", bundle: nil), forCellReuseIdentifier: "AppointmentNewCell")
        appointmentListTableView.rowHeight = 115
        appointmentListTableView.separatorStyle = .none
        
//        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
//        navigationController?.navigationBar.layer.shadowRadius = 10
//        navigationController?.navigationBar.layer.shadowOpacity = 0.2
        
        topNavigationBar.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        topNavigationBar.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //MARK:- Observe Query: Get Appointment list
        observeQuery()
        print("Token: ", student.fcmToken)
    }
    
    func createMenuBar() {
        
        
        //Create Menu Bar
        sidebarView = SideBarView(frame: CGRect(x: 0, y: 0, width: 0, height: self.view.frame.height))
        sidebarView.userType = userType
        if userType == "Student" {
            sidebarView.student = student
        } else {
            sidebarView.userProfessor = userProfessor
        }
        sidebarView.delegate = self
        
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
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToProfessorList", sender: self)
        
    }
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToCalendar", sender: self)
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
                self.filterPendingAppointments()
                self.appointmentListTableView.reloadData()
            })
    }
    
    func filterPendingAppointments() {
        let today = Date()
        
        pendingAppointments = appointments.filter({ (Appointment) -> Bool in
            if Appointment.startTime.compare(today) == .orderedDescending {
                return true
            } else {
                return false
            }
        })
    }
    
    
    
    
    //MARK:- Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAppointmentView" {
            guard let indexPath = appointmentListTableView.indexPathForSelectedRow else {
                return }
            if let destinationVC = segue.destination as? AppointmentViewController {
                destinationVC.appointment = pendingAppointments[indexPath.row]
                destinationVC.userType = userType
                destinationVC.documentSnapshot = documents[indexPath.row]
            }
        }
        if segue.identifier == "goToProfessorList" {
            if let destinationVC = segue.destination as? ProfessorListController {
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
                destinationVC.userType = userType
                
            }
        }
        if segue.identifier == "goToCalendar" {
            if let destinationVC = segue.destination as? ViewController {
                destinationVC.student = student
                destinationVC.appointments = appointments
                destinationVC.documents = documents
                destinationVC.userProfessor = userProfessor
                destinationVC.userType = userType
            }
        }
        if segue.identifier == "goToProfileView" {
            if let destinationVC = segue.destination as? ProfileController {
                destinationVC.userType = userType
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
            }
        }
    }


   
}

extension AppointmentListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return appointments.count
        return pendingAppointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appointmentListTableView.dequeueReusableCell(withIdentifier: "AppointmentNewCell", for: indexPath) as! AppointmentNewCell
    
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        cell.appointmentDateTimeLabel.text = "\(dateFormatter.string(from: pendingAppointments[indexPath.row].startTime))"
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.appointmentDateTimeLabel.text = "\(cell.appointmentDateTimeLabel.text!) at \(dateFormatter.string(from: pendingAppointments[indexPath.row].startTime))"
        
        cell.professorNameLabel.text = pendingAppointments[indexPath.row].profName
        cell.statusLabel.text = pendingAppointments[indexPath.row].status.uppercased()
        
        cell.appointmentDateTimeLabel.textColor = pendingStatusTextColor
        cell.professorNameLabel.textColor = pendingStatusTextColor
        cell.viewBlock.backgroundColor = pendingStatusBackgroundColor
        cell.statusLabel.textColor = pendingStatusColor
        cell.profPictureImageView.image = UIImage(named: "profile_icon")
        cell.profPictureImageView.contentMode = .scaleAspectFill
        let profPictureStorageRef = Storage.storage().reference().child("professor/\(pendingAppointments[indexPath.row].profId)")
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
        appointmentListTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AppointmentListController : SidebarViewDelegate {
    func sidebarDidSelectRow(row: Row) {
        if row == Row(row: 1) {
            performSegue(withIdentifier: "goToProfileView", sender: self)
            blackScreen.isHidden = true
            blackScreen.frame = self.view.bounds
            blackScreen.alpha = 1
            UIView.animate(withDuration: 0.3) {
                self.sidebarView.frame = CGRect(x: 0, y: 0, width: 0, height: self.sidebarView.frame.height)
                self.blackScreen.alpha = 0
            }
            
        } else if row == Row(row: 3) {
            let alert = UIAlertController(title: "Are you Sure?", message: "Select Yes to logout or No to cancel", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                
                do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                UserDefaults.standard.removeObject(forKey: "firstName")
                UserDefaults.standard.removeObject(forKey: "lastName")
                UserDefaults.standard.removeObject(forKey: "emailId")
                if self.userType == "Student" {
                    UserDefaults.standard.removeObject(forKey: "username")
                    UserDefaults.standard.removeObject(forKey: "studentId")
                    UserDefaults.standard.removeObject(forKey: "degree")
                    UserDefaults.standard.removeObject(forKey: "major")
                } else {
                    UserDefaults.standard.removeObject(forKey: "profId")
                    UserDefaults.standard.removeObject(forKey: "title")
                    UserDefaults.standard.removeObject(forKey: "dept")
                   // UserDefaults.standard.removeObject(forKey: "designation")
                }
                UserDefaults.standard.removeObject(forKey: "userType")
                UserDefaults.standard.removeObject(forKey: "fcmToken")
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WelcomeController")
                let navVC = UINavigationController(rootViewController: vc)
                
                let share = UIApplication.shared.delegate as? AppDelegate
                share?.window?.rootViewController = navVC
                share?.window?.makeKeyAndVisible()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
