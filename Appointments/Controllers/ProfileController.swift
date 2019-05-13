//
//  ProfileController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/11/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileDetailsTableView: UITableView!
    
    @IBOutlet weak var profileDetailsTableHeightContraint: NSLayoutConstraint!
    //MARK:- Global Variables
    var userType = ""
    
    var student = Student()
    var userProfessor = Professor()
    
    var profileRowTitles = [String]()
    var profileRowValues = [String]()
    
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topNavigationBar.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        topNavigationBar.backBarButtonItem?.tintColor = UIColor.white
        
        if userType == "Student" {
            profileRowTitles = ["FirstName", "LastName", "StudentId", "Degree Level", "Major's"]
            profileRowValues = [student.firstName, student.lastName, student.studentId, student.degreeLevel, student.major]
        } else {
            profileRowTitles = ["FirstName", "LastName", "Department", "Designation", "Schedule"]
            
            profileRowValues = [userProfessor.firstName, userProfessor.lastName, userProfessor.dept, userProfessor.designation, ""]
            profileDetailsTableHeightContraint.constant = 225
            fetchScheduleForUserProfessor()
        }
        
        profileDetailsTableView.delegate = self
        profileDetailsTableView.dataSource = self
        
        profileDetailsTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        profileDetailsTableView.rowHeight = 45
        profileDetailsTableView.isScrollEnabled = false
        profileDetailsTableView.separatorStyle = .none
        
        profileDetailsTableView.reloadData()
    }
    
    func fetchScheduleForUserProfessor() {
        SVProgressHUD.show()
        var db = Firestore.firestore()
        let query = db.collection("Professors").whereField("profId", isEqualTo: userProfessor.profId)
        
        query.getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot result: \(error)")
                return
            }
            
            if snapshot.documents.count > 0 {
                for doc in snapshot.documents {
                    
                    if let model = Professor(dictionary: doc.data()) {
                        self.userProfessor = model
                    }  else {
                        print("Unable to initialize \(Professor.self) with document data \(doc.data())")
                    }
                    
                }
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdateProfileInfo" {
            guard let indexPath = profileDetailsTableView.indexPathForSelectedRow else {return}
            if let destinationVC = segue.destination as? updateProfileInfoController {
                destinationVC.delegate = self
                destinationVC.headerText = profileRowTitles[indexPath.row]
                destinationVC.previousValue = profileRowValues[indexPath.row]
                destinationVC.selectedRow = indexPath.row
            }
        }
        if segue.identifier == "goToScheduleController" {
            if let destinationVC = segue.destination as? CreateScheduleController {
                destinationVC.userProfessor = userProfessor
            }
        }
    }
    
    
    
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileRowTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileDetailsTableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
        cell.profileRowTitleLabel.text = profileRowTitles[indexPath.row]
        cell.profileRowValueLabel.text = profileRowValues[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userType != "Student" {
            if indexPath.row == 4 {
                performSegue(withIdentifier: "goToScheduleController", sender: self)
            }
        } else {
            performSegue(withIdentifier: "goToUpdateProfileInfo", sender: self)
        }
    }
    
}

extension ProfileController: UpdateProfileInfoDelegate {
    func updateProfileInfo(atRow row: Int, withValue value: String) {
        profileRowValues[row] = value
        profileDetailsTableView.reloadData()
    }
}
