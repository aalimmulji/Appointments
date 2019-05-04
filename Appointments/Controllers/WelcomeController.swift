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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authUI = FUIAuth.defaultAuthUI()!
        
        authUI.delegate = self
        let providers : [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        
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
        print(authDataResult?.additionalUserInfo?.profile)
        
    }
    
    //MARK:- SignUp Button IBAction

    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let authUI = FUIAuth.defaultAuthUI()!
        
        authUI.delegate = self
        let providers : [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers
        
        let authViewController = authUI.authViewController()
        //let instanceOfAuthVC = self.storyboard!.instantiateViewController(withIdentifier: "authViewController") as! ViewController
        //authViewController.navigationItem.title = "Welcome to Appointments"
       //     .titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]

        authViewController.navigationBar.topItem?.title = "Welcome to Appointments"
        authViewController.navigationBar.barTintColor = UIColor(colorWithHexValue: 0x3F77D4)
        authViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        authViewController.navigationBar.tintColor = UIColor.black
        
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

