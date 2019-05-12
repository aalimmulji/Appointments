//
//  AppointmentViewController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/29/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class AppointmentViewController: UIViewController {
    
    //MARK:- IBOutlets

    @IBOutlet weak var acceptAppointmentButton: UIButton!
    @IBOutlet weak var rejectAppointmentButton: UIButton!
    @IBOutlet weak var statusBarLabel: UILabel!
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var dateOfAppointmentLabel: UILabel!
    @IBOutlet weak var timeSlotOfAppointmentLabel: UILabel!
    
    @IBOutlet weak var editTimeSlotButton: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK:- Global Variables
    
    var accpetButtonColor = UIColor(colorWithHexValue: 0x65DBBD)
    var rejectButtonColor = UIColor(colorWithHexValue: 0x133543)
    
    var pendingStatusTextColor = UIColor(colorWithHexValue: 0x0F4352)
    
    
    var userType = ""
    var appointment = Appointment()
    var dateFormatter = DateFormatter()
    let db = Firestore.firestore()
    var documentSnapshot : DocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if userType == "Student" {
            statusBarLabel.isHidden = false
            statusBarLabel.text = appointment.status.uppercased()
            statusBarLabel.textColor = pendingStatusTextColor
            
        } else {
            statusBarLabel.isHidden = true
        }
        acceptAppointmentButton.layer.borderColor = accpetButtonColor.cgColor
        rejectAppointmentButton.layer.borderColor = rejectButtonColor.cgColor
        
        if appointment.status == "Accepted" {
            acceptAppointmentButton.backgroundColor = accpetButtonColor
            acceptAppointmentButton.setTitleColor(.white, for: .normal)
        } else if appointment.status == "Rejected" {
            rejectAppointmentButton.backgroundColor = rejectButtonColor
            rejectAppointmentButton.setTitleColor(.white, for: .normal  )
        }
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        studentNameLabel.text = appointment.profName
        dateOfAppointmentLabel.text = dateFormatter.string(from: appointment.startTime)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        timeSlotOfAppointmentLabel.text = "\(dateFormatter.string(from: appointment.startTime)) - \(dateFormatter.string(from: appointment.endTime))"
        descriptionTextView.text = appointment.description
        
        
        
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.acceptAppointmentButton.backgroundColor = self.accpetButtonColor
            self.acceptAppointmentButton.setTitleColor(.white, for: .normal)
            self.rejectAppointmentButton.backgroundColor = UIColor.white
            self.rejectAppointmentButton.setTitleColor(self.rejectButtonColor, for: .normal)
        }
        
        let documentRef = db.collection("appointments").document(documentSnapshot!.documentID)
        documentRef.updateData([
            "status": "Accepted"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    @IBAction func rejectButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.acceptAppointmentButton.backgroundColor = UIColor.white
            self.acceptAppointmentButton.setTitleColor(self.accpetButtonColor, for: .normal)
            self.rejectAppointmentButton.backgroundColor = self.rejectButtonColor
            self.rejectAppointmentButton.setTitleColor(.white, for: .normal)
        }
        
        let documentRef = db.collection("appointments").document(documentSnapshot!.documentID)
        documentRef.updateData([
            "status": "Rejected"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}

//extension UISegmentedControl {
//    func removeBorders() {
//        setBackgroundImage(imageWithColor(color: UIColor.white), for: .normal, barMetrics: .default)
//        setBackgroundImage(imageWithColor(color: UIColor.blue), for: .selected, barMetrics: .default)
//        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//    }
//
//    // create a 1x1 image with this color
//    private func imageWithColor(color: UIColor) -> UIImage {
//        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor);
//        context!.fill(rect);
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image!
//    }
//}
