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
    var student = Student()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentButtonWidthConstraint.constant = self.view.frame.width / 2
        professorButtonWidthConstraint.constant = self.view.frame.width / 2
        
        let authUI = FUIAuth.defaultAuthUI()!
        
        if Auth.auth().currentUser != nil {
            print("current user is signed In")
            //performSegue(withIdentifier: "goToHomePage", sender: self)
        }
            
            
//        } else {
//
//            authUI.delegate = self
//            let providers : [FUIAuthProvider] = [
//                FUIGoogleAuth()
//            ]
//            authUI.providers = providers
//
//            let authViewController = authUI.authViewController()
//            //authViewController.isNavigationBarHidden = true
//
//            authViewController.navigationBar.topItem?.title = "Appointments"
//            authViewController.navigationBar.barTintColor = UIColor(colorWithHexValue: 0x3F77D4)
//            authViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
//            authViewController.navigationBar.tintColor = UIColor.black
//
//            let instanceOfAuthVC = authViewController.viewControllers.first as! UIViewController
//
//
//            let appImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 235, height: 235))
//            appImage.image = UIImage(named: "home_icon")
//            appImage.contentMode = .scaleAspectFit
//            appImage.translatesAutoresizingMaskIntoConstraints = false
//
//            instanceOfAuthVC.view.addSubview(appImage)
//
//            appImage.centerXAnchor.constraint(equalTo: instanceOfAuthVC.view.centerXAnchor).isActive = true
//            appImage.centerYAnchor.constraint(equalTo: instanceOfAuthVC.view.centerYAnchor).isActive = true
//
//
//
//            self.present(authViewController, animated: true, completion: nil)
            
//        }
        
        //MARK:- HIde Navigation bar
        navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .default
        
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
            if let firstName = profileDictionary["given_name"] as? String {
                student.firstName = firstName
            }
            if let lastName = profileDictionary["family_name"] as? String {
                student.lastName = lastName
            }
            if let emailId = profileDictionary["email"] as? String {
                student.emailId = emailId
                performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
            } else {
                let alert = UIAlertController(title: "Email error", message: "Seems to be some problem with your email. Please contact your university", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK:- SignUp Button IBAction

    @IBAction func signUpButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "goToStepTwoSignUpPage", sender: self)
//        let stepTwoSignUp = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StepTwoSignUpController") as? StepTwoSignUpController
//        self.navigationController?.pushViewController(stepTwoSignUp!, animated: true)
        let buttonPressed = sender as! UIButton
        if buttonPressed.titleLabel?.text == "Student" {
            print("Student Button")
        } else {
            print("Professor Button")
        }
        let authUI = FUIAuth.defaultAuthUI()!

        authUI.delegate = self
        let providers : [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers

        let authViewController = authUI.authViewController()

        authViewController.navigationBar.topItem?.title = buttonPressed.titleLabel?.text?.uppercased()
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

