//
//  ViewController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/2/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.scrollDirection = .horizontal
        
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
//        calendar.dataSource = self
//        calendar.delegate = self
//        
//        calendar.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(calendar)
//        
//        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        calendar.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        self.calendar = calendar
        
    }
    
    @IBAction func weekMode(_ sender: Any) {
            
        calendar.scope = .week
    }
    
    @IBAction func monthMode(_ sender: Any){
        calendar.scope = .month
    }
    @IBAction func dayMode(_ sender: Any) {
        
        let dayViewController = CalendarKitMainController()
        performSegue(withIdentifier: "goToCalendarKit", sender: self)
    }
    
}

extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
    }
    
    
    
                
    
}

