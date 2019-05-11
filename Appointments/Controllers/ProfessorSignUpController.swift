//
//  ProfessorSignUpController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/10/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class ProfessorSignUpController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
    }
    
}
