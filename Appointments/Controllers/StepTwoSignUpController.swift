//
//  StepTwoSignUpController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/3/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class StepTwoSignUpController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var studentIdTextField: UITextField!
    @IBOutlet weak var degreeLevelTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    
    //MARK:- Global Variables
    
    var user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        if let studentId = studentIdTextField.text {
            user.studentId = studentId
        }
        if let degreeLevel = degreeLevelTextField.text {
            user.degreeLevel = degreeLevel
        }
        if let major = majorTextField.text {
            user.major = major
        }
        user.username = String(user.email.split(separator: "@")[0])
        performSegue(withIdentifier: "goToImageUploadPage", sender: self)
    }
    
    //MARK:- Prepare for Segue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImageUploadPage" {
            if let destinationVC = segue.destination as? ImageUploadController {
                destinationVC.user = user
            }
        }
    }
    

}
