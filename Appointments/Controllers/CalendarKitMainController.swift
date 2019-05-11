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
import Firebase

enum SelectedStyle {
    case Dark
    case Light
}

class CalendarKitMainController: DayViewController, DatePickerControllerDelegate {

    var weekDays = ["Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat"]
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
    
//  var data = [[String]]()
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    var currentStyle = SelectedStyle.Light
    
    let db = Firestore.firestore()
    var professor = Professor()
    var profSchedules = [ProfSchedule]()
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
    
    var selectedDayScheduleTimeslots = [String]()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CalendarKit"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dark", style: .done, target: self, action: #selector(CalendarKitMainController.changeStyle))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ChangeDate", style: .plain, target: self, action: #selector(CalendarKitMainController.presentDatePicker))
        
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        
        //MARK:- Get Professor Schedule from fireStore
       // getProfessorSchedule()
        addProfScheduleToModel(professor: professor)
        
        //reloadData()
    }
    
    func addProfScheduleToModel(professor: Professor) {
        
        for dayScheduleDictionary in professor.Schedule {
            
            var profSchedule = ProfSchedule()
            
            profSchedule.profId = professor.profId
            profSchedule.dayOfTheWeek = dayScheduleDictionary.key
            
            if let dayScheduleValues = dayScheduleDictionary.value as? [String: Any] {
                
                for daySchedule in dayScheduleValues {
                    if daySchedule.key == "isAvailableToday" {
                        if let isAvailableToday = daySchedule.value as? Bool {
                            profSchedule.isAvailableToday = isAvailableToday
                        }
                    } else {
                        if let daySchedule = daySchedule.value as? [String: Any] {
                            for scheduleDictionary in daySchedule {
                                var schedule = Schedule()
                                schedule.scheduleId = Int(scheduleDictionary.key)!
                                if let scheduleValues = scheduleDictionary.value as? [String: Any] {
                                    for sc in scheduleValues {
                                        if sc.key == "timeSlot" {
                                            if let timeSlot = sc.value as? String {
                                                schedule.timeSlot = timeSlot
                                            }
                                        } else if sc.key == "type" {
                                            if let type = sc.value as? String {
                                                schedule.type = type
                                            }
                                        }
                                    }
                                    profSchedule.schedule.append(schedule)
                                }
                            }
                        }
                    }
                }
                
                profSchedules.append(profSchedule)
            }
            
            
        }
        
        print("Professor Schedule: \n", profSchedules)
        self.reloadData()
        
    }
    
    func getProfessorSchedule() {
        let query = db.collection("Professors").whereField("profId", isEqualTo: "mahmood")
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    if let models = Professor(dictionary: document.data()) {
                        print("Professor: \(models.profId) \n", models)
                        
                        self.professor = models
                        self.addProfScheduleToModel(professor: self.professor)
                        self.reloadData()
                    }
                }
            }
        }
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
    
    //MARK: Event DataSource
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        
//        var date = date.add(TimeChunk.dateComponents(hours: Int(arc4random_uniform(10) + 5)))
//        var events = [Event]()
//
//        for i in 0...4 {
//            let event = Event()
//            let duration = Int(arc4random_uniform(160) + 60)
//
//            let datePeriod = TimePeriod(beginning: date, chunk: TimeChunk.dateComponents(minutes: duration))
//
//            event.startDate = datePeriod.beginning!
//            event.endDate = datePeriod.end!
//
//            var info = data[Int(arc4random_uniform(UInt32(data.count)))]
//
//            let timezone = TimeZone.ReferenceType.default
//            info.append(datePeriod.beginning!.format(with: "dd.MM.YYYY", timeZone: timezone))
//            info.append("\(datePeriod.beginning!.format(with: "HH:mm", timeZone: timezone)) - \(datePeriod.end!.format(with: "HH:mm", timeZone: timezone))")
//
//            event.text = info.reduce("", {$0 + $1 + "\n"})
//            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
//            event.isAllDay = Int(arc4random_uniform(2)) % 2 == 0
//
//
//            // Events styles are updated independently from CalendarStyle
//            // Hence the need to specify exact colors in case of Dark Style
//            if currentStyle == .Dark {
//                event.textColor = textColorForEventInDarkTheme(baseColor: event.color)
//                event.backgroundColor = event.color.withAlphaComponent(0.6)
//            }
//
//            events.append(event)
//
//            let nextOffset = Int(arc4random_uniform(250) + 40)
//            date = date.add(TimeChunk.dateComponents(minutes: nextOffset))
//
//            event.userInfo = String(i)
//        }
        
        var events = [Event]()
        
        var tempDate = date
            if let allSchedulesForToday = professor.Schedule[weekDays[date.weekday-1]] as? [String: Any] {

                if let isAvailableToday = allSchedulesForToday["isAvailableToday"] as? Bool {

                    if isAvailableToday {


                        if let schedulesForToday = allSchedulesForToday["schedule"] as? [String: Any] {

                            for schedule in schedulesForToday {
                                let event = Event()
                                event.userInfo = schedule.key
                                
                                if let scheduleData = schedule.value as? [String: Any] {
                                    
                                    
                                    if let timeSlot = scheduleData["timeSlot"] as? String {
                                        
                                        let startTime = String(timeSlot.split(separator: "-")[0])
                                        let endTime = String(timeSlot.split(separator: "-")[1])
                                        
                                        let startHour = String(startTime.split(separator: ":")[0])
                                        
                                        tempDate.hour(Int(startHour)!)
                                        let startDate = tempDate
                                        
                                        let endHour = String(endTime.split(separator: ":")[0])
                                        
                                        tempDate.hour(Int(endHour)!)
                                        let endDate = tempDate
                                        
                                        let datePeriod = TimePeriod(beginning: startDate, end: endDate)
                                        
                                        event.startDate = datePeriod.beginning!
                                        event.endDate = datePeriod.end!
                                        
                                    }
                                    
                                    if let type = scheduleData["type"] as? String {
                                        event.text = "\(event.startDate.format(with: "HH:mm")) - \(event.endDate.format(with: "HH:mm")) - \(type)"
                                        event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
                                        
                                    }
                                    
                                }

                                events.append(event)

                            }
                        }
                    }
                }
            }
        
        return events
    }
    
    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
    }
    
    
    
    //MARK: DayView Delegate
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        
        selectedDayScheduleTimeslots = [String]()
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
        if let allSchedulesForToday = professor.Schedule[weekDays[descriptor.startDate.weekday-1]] as? [String: Any] {
                    
            if let schedulesForToday = allSchedulesForToday["schedule"] as? [String: Any] {
                
                for schedule in schedulesForToday {
                    
                    if let scheduleData = schedule.value as? [String: Any] {
                        
                        if let timeSlot = scheduleData["timeSlot"] as? String {
                            selectedDayScheduleTimeslots.append(timeSlot)
                        }
                        
                    }
                    
                }
            }
        }
        performSegue(withIdentifier: "goToNewAppointment", sender: self)
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been long pressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        //print("DayView = \(dayView) did move to = \(date)")
        selectedDate = date
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        //print("DayVew = \(dayView) will move to = \(date)")
    }
    
    
    //MARK:- Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewAppointment" {
            
            if let destinationVC = segue.destination as? NewAppointmentController {
                destinationVC.professor = professor
                destinationVC.selectedDayScheduleTimeslots = selectedDayScheduleTimeslots
                destinationVC.selectedDate = selectedDate
                destinationVC.student = student
                destinationVC.userProfessor = userProfessor
                destinationVC.userType = userType
            }
        }
    }

}
