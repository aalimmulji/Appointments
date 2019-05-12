//
//  WelcomeController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/3/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class WelcomeController: UIViewController, FUIAuthDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var homeIconImageView: UIImageView!
    
    @IBOutlet weak var studentButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var professorButtonWidthConstraint: NSLayoutConstraint!


    //MARK:- Global Variables
    
    var userType : String = ""
    var student = Student()
    var userProfessor = Professor()
    var isNewUser = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentButtonWidthConstraint.constant = self.view.frame.width / 2
        professorButtonWidthConstraint.constant = self.view.frame.width / 2
        
        if Auth.auth().currentUser != nil {
            print("current user is signed In")
            if let usertype = UserDefaults.standard.value(forKey: "userType") as? String {
                userType = usertype
            }
            if userType == "Student" {
                getStudentDataFromUserDefaults()
            } else {
                getProfessorDataFromUserDefaults()
            }
            performSegue(withIdentifier: "goToHomePage", sender: self)
        }
        
        
        //MARK:- HIde Navigation bar
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
        
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
        let pushManager = PushNotificationManager()
        pushManager.updateFirestorePushTokenIfNeeded()
        
        
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
        let pushManager = PushNotificationManager()
        pushManager.updateFirestorePushTokenIfNeeded()
        

    }
    
    func getStudentDataFromUserDefaults() {
        if let firstName = UserDefaults.standard.value(forKey: "firstName") as? String {
            student.firstName = firstName
        }
        if let lastName = UserDefaults.standard.value(forKey: "lastName") as? String {
            student.lastName = lastName
        }
        if let emailId = UserDefaults.standard.value(forKey: "emailId") as? String {
            student.emailId = emailId
        }
        if let username = UserDefaults.standard.value(forKey: "username") as? String {
            student.username = username
        }
        if let studentId = UserDefaults.standard.value(forKey: "studentId") as? String {
            student.studentId = studentId
        }
        if let degree = UserDefaults.standard.value(forKey: "degree") as? String {
            student.degreeLevel = degree
        }
        if let major = UserDefaults.standard.value(forKey: "major") as? String {
            student.major = major
        }
        if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            student.fcmToken = token
        }
        
    }
    
    func getProfessorDataFromUserDefaults() {
        if let firstName = UserDefaults.standard.value(forKey: "firstName") as? String {
            userProfessor.firstName = firstName
        }
        if let lastName = UserDefaults.standard.value(forKey: "lastName") as? String {
            userProfessor.lastName = lastName
        }
        if let emailId = UserDefaults.standard.value(forKey: "emailId") as? String {
            userProfessor.emailId = emailId
        }
        if let profId = UserDefaults.standard.value(forKey: "profId") as? String {
            userProfessor.profId = profId
        }
        if let title = UserDefaults.standard.value(forKey: "title") as? String {
            userProfessor.title = title
        }
        if let dept = UserDefaults.standard.value(forKey: "dept") as? String {
            userProfessor.dept = dept
        }
        if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            userProfessor.fcmToken = token
        }
        if let designation = UserDefaults.standard.value(forKey: "designation") as? String {
            userProfessor.designation = designation
        }
    }
    
    func isNewStudent() {
        var db = Firestore.firestore()
        let query = db.collection("students").whereField("username", isEqualTo: student.username)
        query.getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot result: \(error)")
                return
            }
        
            if snapshot.documents.count > 0 {
                for doc in snapshot.documents {
                    if let model = Student(dictionary: doc.data()) {
                        self.student = model
                        self.setStudentDataToUserDefaults()
                        self.performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
                        //self.performSegue(withIdentifier: "goToHomePage", sender: self)
                    }  else {
                        print("Unable to initialize \(Student.self) with document data \(doc.data())")
                    }
                    
                }
            } else {
                var newStdDoc = db.collection("students").document()
                newStdDoc.setData(self.student.dictionary) {
                    err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.setStudentDataToUserDefaults()
                        self.performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
                        //self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    func isNewProfessor() {
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
                        
                        self.setProfessorDataToUserDefaults()
                        self.performSegue(withIdentifier: "goToHomePage", sender: self)
                    }  else {
                        print("Unable to initialize \(Professor.self) with document data \(doc.data())")
                    }
                    
                }
            } else {
                var newProfDoc = db.collection("Professors").document()
                newProfDoc.setData(self.userProfessor.dictionary) {
                    err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.setProfessorDataToUserDefaults()
                        self.performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
                        //self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    //MARK:- FUIAuth delegate methods
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let profileDictionary = authDataResult?.additionalUserInfo?.profile {
            print(profileDictionary)
            UserDefaults.standard.set(userType, forKey: "userType")
            if let token = Messaging.messaging().fcmToken {
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }
            if userType == "Student" {
                if let token = Messaging.messaging().fcmToken {
                    student.fcmToken = token
                }
                if let firstName = profileDictionary["given_name"] as? String {
                    student.firstName = firstName
                }
                if let lastName = profileDictionary["family_name"] as? String {
                    student.lastName = lastName
                }
                if let emailId = profileDictionary["email"] as? String {
                    student.emailId = emailId
                    student.username = String(student.emailId.split(separator: "@")[0])
                    isNewStudent()
                } else {
                    let alert = UIAlertController(title: "Email error", message: "Seems to be some problem with your email. Please contact your university", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                if let token = Messaging.messaging().fcmToken {
                    userProfessor.fcmToken = token
                }
                if let firstName = profileDictionary["given_name"] as? String {
                    userProfessor.firstName = firstName
                }
                if let lastName = profileDictionary["family_name"] as? String {
                    userProfessor.lastName = lastName
                }
                if let emailId = profileDictionary["email"] as? String {
                    userProfessor.emailId = emailId
                    userProfessor.profId = String(userProfessor.emailId.split(separator: "@")[0])
                    
                    isNewProfessor()
                } else {
                    let alert = UIAlertController(title: "Email error", message: "Seems to be some problem with your email. Please contact your university", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    //MARK:- SignUp Button IBAction

    @IBAction func signUpButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
//        let stepTwoSignUp = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StepTwoSignUpController") as? StepTwoSignUpController
//        self.navigationController?.pushViewController(stepTwoSignUp!, animated: true)
        
        let buttonPressed = sender as! UIButton
        
        userType = (buttonPressed.titleLabel?.text)!
        let authUI = FUIAuth.defaultAuthUI()!

        authUI.delegate = self
        
        let providers : [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers

        let authViewController = authUI.authViewController()

        authViewController.navigationBar.topItem?.title = userType.uppercased()
        authViewController.navigationBar.barTintColor = UIColor(colorWithHexValue: 0x397888)
        authViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        authViewController.navigationBar.tintColor = UIColor.black
        
        authViewController.navigationBar.layer.shadowColor = UIColor(colorWithHexValue: 0x57A6A3).cgColor
        authViewController.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        authViewController.navigationBar.layer.shadowRadius = 10
        authViewController.navigationBar.layer.shadowOpacity = 0.7

        let instanceOfAuthVC = authViewController.viewControllers.first as! UIViewController
        let appImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 235, height: 235))
        appImage.image = UIImage(named: "home_icon")
        appImage.contentMode = .scaleAspectFit
        appImage.translatesAutoresizingMaskIntoConstraints = false

        instanceOfAuthVC.view.addSubview(appImage)

        appImage.centerXAnchor.constraint(equalTo: instanceOfAuthVC.view.centerXAnchor).isActive = true
        appImage.centerYAnchor.constraint(equalTo: instanceOfAuthVC.view.centerYAnchor).isActive = true



        self.present(authViewController, animated: true, completion: nil)
    }
    
    
    //MARK:- Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStepTwoSignUpPage" {
            if let destinationVC = segue.destination as? StepTwoSignUpController {
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
                destinationVC.userType = userType
            }
        }
        if segue.identifier == "goToHomePage" {
            if let homeNC = segue.destination as? UINavigationController {
                if let destinationVC = homeNC.topViewController as? AppointmentListController {
                    destinationVC.userType = userType
                    destinationVC.student = student
                    destinationVC.userProfessor = userProfessor
                }
            }
        }
    }
}


@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

