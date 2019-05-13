//
//  Appointment.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/14/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation
import Firebase

struct Appointment {
    
    //var id : String = ""
    var startTime: Date = Date()
    var endTime : Date = Date()
    var duration : Int = 0
    var description : String = ""
    var profId : String = ""
    var studentUsername : String = ""
    var studentName: String = ""
    var profName : String = ""
    var status : String = ""
    var date : String = ""
    var documentId : String = ""
    
    var dictionary : [String: Any] {
        return [
           // "id": id,
            "startTime": startTime,
            "endTime": endTime,
            "duration": duration,
            "description": description,
            "profId": profId,
            "studentUsername": studentUsername,
            "studentName" : studentName,
            "profName" : profName,
            "status": status,
            "date": date,
            "documentId" : documentId
        ]
    }
}

extension Appointment : DocumentSerializable {
    init?(dictionary: [String : Any]) {
       // guard let id = dictionary["id"] as? String,
        guard let duration = dictionary["duration"] as? Int,
            let description = dictionary["description"] as? String,
            let profId = dictionary["profId"] as? String,
            let studentUsername = dictionary["studentUsername"] as? String,
            let studentName = dictionary["studentName"] as? String,
            let profName = dictionary["profName"] as? String,
            let date = dictionary["date"] as? String,
            let documentId = dictionary["documentId"] as? String,
            let status = dictionary["status"] as? String else {return nil}
        
        var startTime = Date(), endTime = Date()
        
        if let startT = dictionary["startTime"] as? Timestamp  {
            startTime = Date(timeIntervalSince1970: Double(startT.seconds))

            var formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .long
            
            
            formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            
            var startTimeString = formatter.string(from: startTime)
            print("Start Time String: ", startTimeString)
            print("Curren Timezone: ", TimeZone.current.abbreviation())
            formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            startTime = formatter.date(from: startTimeString)!
        }
        
        if let endT = dictionary["endTime"] as? Timestamp {
            endTime = Date(timeIntervalSince1970: Double(endT.seconds))

            var formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .long
            
            formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)

            var endTimeString = formatter.string(from: endTime)
            
            print("EndTimeString:", endTimeString)
            formatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
            endTime = formatter.date(from: endTimeString)!
        }
        
        self.init(//id : id,
                  startTime: startTime,
                  endTime: endTime,
                  duration: duration,
                  description: description,
                  profId: profId,
                  studentUsername : studentUsername,
                  studentName: studentName,
                  profName: profName,
                  status: status,
                  date: date,
                  documentId: documentId)
    }
}
