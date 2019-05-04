//
//  AppointmentViewController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/29/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    @IBOutlet weak var acceptAppointmentButton: UIButton! {
        didSet {
            acceptAppointmentButton.layer.borderWidth = 1
            acceptAppointmentButton.layer.borderColor = UIColor(colorWithHexValue: 0x00F900).cgColor
            acceptAppointmentButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var rejectAppointmentButton: UIButton! {
        didSet {
            rejectAppointmentButton.layer.borderWidth = 1
            rejectAppointmentButton.layer.borderColor = UIColor(colorWithHexValue: 0xFF2600).cgColor
            rejectAppointmentButton.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var dateOfAppointmentLabel: UILabel!
    @IBOutlet weak var timeSlotOfAppointmentLabel: UILabel!
    
    @IBOutlet weak var editTimeSlotButton: UIButton!
    
    
    @IBOutlet weak var appoinmentResponseSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
