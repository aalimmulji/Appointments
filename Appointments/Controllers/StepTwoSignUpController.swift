//
//  StepTwoSignUpController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/3/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class StepTwoSignUpController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var studentIdTextField: UITextField!
    @IBOutlet weak var degreeLevelTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    
    //MARK:- Global Variables
    var userType = ""
    var student = Student()
    var userProfessor = Professor()
    var db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userType == "Student" {
            studentIdTextField.placeholder = "Student Id"
            degreeLevelTextField.placeholder = "Degree Level"
            majorTextField.placeholder = "Major"
        } else {
            studentIdTextField.placeholder = "Department"
            degreeLevelTextField.placeholder = "Designation"
            majorTextField.placeholder = "Title"
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if userType == "Student" {
            if let studentId = studentIdTextField.text {
                student.studentId = studentId
            }
            if let degreeLevel = degreeLevelTextField.text {
                student.degreeLevel = degreeLevel
            }
            if let major = majorTextField.text {
                student.major = major
            }
            if let token = Messaging.messaging().fcmToken {
                student.fcmToken = token
            }
            setStudentDataToUserDefaults()
            
            let query = db.collection("students").whereField("username", isEqualTo: student.username)
            query.getDocuments { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshot result: \(error)")
                    return
                }
                
                if snapshot.documents.count > 0 {
                    for doc in snapshot.documents {
                        doc.reference.setData(self.student.dictionary) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                               self.performSegue(withIdentifier: "goToImageUploadPage", sender: self)
                            }
                        }
                    }
                }
            }
        } else {
            if let dept = studentIdTextField.text {
                userProfessor.dept = dept
            }
            if let designation = degreeLevelTextField.text?.uppercased() {
                userProfessor.designation = designation
            }
            if let title = majorTextField.text {
                userProfessor.title = title
            }
            if let token = Messaging.messaging().fcmToken {
                userProfessor.fcmToken = token
            }
            setProfessorDataToUserDefaults()
            let query = db.collection("Professors").whereField("profId", isEqualTo: userProfessor.profId)
            query.getDocuments { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshot result: \(error)")
                    return
                }
                
                if snapshot.documents.count > 0 {
                    for doc in snapshot.documents {
                        doc.reference.setData(self.userProfessor.dictionary) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                                self.performSegue(withIdentifier: "goToImageUploadPage", sender: self)
                            }
                        }
                    }
                }
            }

        }
    }

    func setStudentDataToUserDefaults() {
        UserDefaults.standard.set(student.firstName, forKey: "firstName")
        UserDefaults.standard.set(student.lastName, forKey: "lastName")
        UserDefaults.standard.set(student.emailId, forKey: "emailId")
        UserDefaults.standard.set(student.username, forKey: "username")
        UserDefaults.standard.set(student.studentId, forKey: "studentId")
        UserDefaults.standard.set(student.degreeLevel, forKey: "degree")
        UserDefaults.standard.set(student.major, forKey: "major")
        //UserDefaults.standard.set(student.fcmToken, forKey: "fcmToken")
    }
    
    func setProfessorDataToUserDefaults() {
        UserDefaults.standard.set(userProfessor.firstName, forKey: "firstName")
        UserDefaults.standard.set(userProfessor.lastName, forKey: "lastName")
        UserDefaults.standard.set(userProfessor.emailId, forKey: "emailId")
        UserDefaults.standard.set(userProfessor.profId, forKey: "profId")
        UserDefaults.standard.set(userProfessor.title, forKey: "title")
        UserDefaults.standard.set(userProfessor.dept, forKey: "dept")
        UserDefaults.standard.set(userProfessor.designation, forKey: "designation")
        //UserDefaults.standard.set(userProfessor.fcmToken, forKey: "fcmToken")
        
    }
    
    //MARK:- Prepare for Segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageUploadPage" {
            if let destinationVC = segue.destination as? ImageUploadController {
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
                destinationVC.userType = userType
            }
        }
    }
    

}
