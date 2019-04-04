//
//  CalendarKitMainController.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/4/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift

enum SelectedStyle {
    case Dark
    case Light
}

class CalendarKitMainController: DayViewController, DatePickerControllerDelegate {

    var data = [["Breakfast at Tiffany's",
                 "New York, 5th avenue"],
                
                ["Workout",
                 "Tufteparken"],
                
                ["Meeting with Alex",
                 "Home",
                 "Oslo, Tjuvholmen"],
                
                ["Beach Volleyball",
                 "Ipanema Beach",
                 "Rio De Janeiro"],
                
                ["WWDC",
                 "Moscone West Convention Center",
                 "747 Howard St"],
                
                ["Google I/O",
                 "Shoreline Amphitheatre",
                 "One Amphitheatre Parkway"],
                
                ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
                 "Oslo Gardermoen"],
                
                ["💻📲 Developing CalendarKit",
                 "🌍 Worldwide"],
                
                ["Software Development Lecture",
                 "Mikpoli MB310",
                 "Craig Federighi"],
                
                ]
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    var currentStyle = SelectedStyle.Light
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CalendarKit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dark", style: .done, target: self, action: #selector(CalendarKitMainController.changeStyle))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ChangeDate", style: .plain, target: self, action: #selector(CalendarKitMainController.presentDatePicker))
        
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
    }
    
    @objc func changeStyle() {
        var title: String!
        var style : CalendarStyle!
        
        if currentStyle == .Dark {
            currentStyle = .Light
            title = "Dark"
            style = StyleGenerator.defaultStyle()
        } else {
            currentStyle = .Dark
            title = "Light"
            style = StyleGenerator.darkStyle()
        }
        
        updateStyle(style)
        navigationItem.rightBarButtonItem!.title = title
        navigationController?.navigationBar.barTintColor = style.header.backgroundColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:style.header.swipeLabel.textColor]
        reloadData()
    }
    
    @objc func presentDatePicker() {
        let picker = DatePickerController()
        picker.date = dayView.state!.selectedDate
        picker.delegate = self
        let navC = UINavigationController(rootViewController: picker)
        navigationController?.present(navC, animated: true, completion: nil)
        
    }
    
    func datePicker(controller: DatePickerController, didSelect date: Date?) {
        if let date = date {
            dayView.state?.move(to: date)
        }
        controller.dismiss(animated: true, completion: nil)
        
        
    }
  

}
