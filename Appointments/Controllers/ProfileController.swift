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

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var profileDetailsTableView: UITableView!
    
    @IBOutlet weak var profileDetailsTableHeightContraint: NSLayoutConstraint!
    //MARK:- Global Variables
    var userType = ""
    //let storage = Storage.storage()

    var student = Student()
    var userProfessor = Professor()
    
    var profileRowTitles = [String]()
    var profileRowValues = [String]()
    var db = Firestore.firestore()
    var instanceOfHome : AppointmentListController?
    
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
        
        displayExistingPicture()
    }
    
    func displayExistingPicture() {
        if userType == "Student" {
            let imageStorageRef = Storage.storage().reference().child("student/\(student.username).jpg")
            imageStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error downloading the image: \(error)")
                } else {
                    let image = UIImage(data: data!)
                    self.profilePictureImageView.image = image
                    self.profilePictureImageView.contentMode = .scaleAspectFit
                }
            }
        } else {
            let imageStorageRef = Storage.storage().reference().child("professor/\(userProfessor.profId).jpg")
            imageStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("Error downloading the image: \(error)")
                } else {
                    let image = UIImage(data: data!)
                    self.profilePictureImageView.image = image
                    self.profilePictureImageView.contentMode = .scaleAspectFit
                }
            }
        }
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
                destinationVC.delegate = self
            }
        }
    }
    
    @IBAction func editProfilePicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "", message: "Choose an option", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = true
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Camera is not available", message: "Please select another option", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker : UIImage?
        if let edit = info[.editedImage] as? UIImage {
            selectedImageFromPicker = edit
        } else if let original = info[.originalImage] as? UIImage {
            selectedImageFromPicker = original
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePictureImageView.image = selectedImage
            profilePictureImageView.contentMode = .scaleAspectFit
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        let data = profilePictureImageView.image?.jpegData(compressionQuality: 0.2) as! Data
        let storageRef = Storage.storage().reference()
        var profilePictureReference = storageRef.child("student/\(student.username).jpg")
        if userType != "Student" {
            profilePictureReference = storageRef.child("professor/\(userProfessor.profId).jpg")
        }
        
        let uploadTask = profilePictureReference.putData(data, metadata: nil) { (metadata, error) in
            
            guard let metadata = metadata else {
                return
            }
            
            if let error = error {
                print("Error: ", error)
            }
            
            let size = metadata.size
            
            profilePictureReference.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    return
                }
                if let error = error {
                    print("Error: ", error)
                }
            })
        }
        
        if userType == "Student" {
            student.firstName = profileRowValues[0]
            student.lastName = profileRowValues[1]
            student.studentId = profileRowValues[2]
            student.degreeLevel = profileRowValues[3]
            student.major = profileRowValues[4]
            
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
                            }
                            SVProgressHUD.dismiss()
                            self.navigationController?.popViewController(animated: true)
                            self.setStudentDataToUserDefaults()
                            self.instanceOfHome?.student = self.student
                            self.instanceOfHome?.createMenuBar()
                            //self.instanceOfSideBar?.layoutIfNeeded()
                        }
                    }
                }
            }
            
            
        } else {
            userProfessor.firstName = profileRowValues[0]
            userProfessor.lastName = profileRowValues[1]
            userProfessor.dept = profileRowValues[2]
            userProfessor.designation = profileRowValues[3]
            
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
                            }
                            SVProgressHUD.dismiss()
                            self.navigationController?.popViewController(animated: true)
                            self.setProfessorDataToUserDefaults()
                            self.instanceOfHome?.userProfessor = self.userProfessor
                            self.instanceOfHome?.createMenuBar()
                            //self.instanceOfSideBar?.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    
    func setStudentDataToUserDefaults() {
        UserDefaults.standard.set(student.firstName, forKey: "firstName")
        UserDefaults.standard.set(student.lastName, forKey: "lastName")
        UserDefaults.standard.set(student.studentId, forKey: "studentId")
        UserDefaults.standard.set(student.degreeLevel, forKey: "degree")
        UserDefaults.standard.set(student.major, forKey: "major")
        //UserDefaults.standard.set(student.fcmToken, forKey: "fcmToken")
    }
    
    func setProfessorDataToUserDefaults() {
        UserDefaults.standard.set(userProfessor.firstName, forKey: "firstName")
        UserDefaults.standard.set(userProfessor.lastName, forKey: "lastName")
        UserDefaults.standard.set(userProfessor.dept, forKey: "dept")
        UserDefaults.standard.set(userProfessor.designation, forKey: "designation")
        //UserDefaults.standard.set(userProfessor.fcmToken, forKey: "fcmToken")
        
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
        profileDetailsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}

extension ProfileController: UpdateProfileInfoDelegate {
    func updateProfileInfo(atRow row: Int, withValue value: String) {
        profileRowValues[row] = value
        profileDetailsTableView.reloadData()
    }
}

extension ProfileController : UpdateScheduleDelegate {
    func updateSchedule(updatedSchedule: [String : Any]) {
        userProfessor.Schedule = updatedSchedule
    }
}
