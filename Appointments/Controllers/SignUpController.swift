//
//  SignUpController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/7/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SignUpController: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Global Variables
    var collRef: CollectionReference!
    var docRef : DocumentReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(FirebaseApp.defaultApp() == nil){
//            FirebaseApp.configure()
//        }
        
        //collRef = Firestore.firestore().collection("Users")

        // Do any additional setup after loading the view.
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        
        let newUser : [String: Any] = ["username": username, "password": password]
        
        collRef.addDocument(data: newUser) { (error) in
            if let error = error {
                print("Error Adding New User: \(error)")
            } else {
                print("New User Document Added!")
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
            }
        }
    }
    
    
    
}
