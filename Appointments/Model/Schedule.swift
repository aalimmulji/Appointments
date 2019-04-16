//
//  Schedule.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/13/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation

struct Schedule {
    
    var scheduleId : Int = -1
    var timeSlot: String = ""
    var type : String = ""
//    
//    var dictionary : [String: Any] {
//        return [
//            "scheduleId": scheduleId,
//            "timeSlot": timeSlot,
//            "type": type
//        ]
//    }
//}
//
//extension Schedule : DocumentSerializable {
//    init?(dictionary: [String : Any]) {
//        guard let scheduleId = dictionary["scheduleId"] as? Int,
//            let timeSlot = dictionary["timeSlot"] as? String,
//            let type = dictionary["type"] as? String else { return nil }
//
//        self.init(scheduleId: scheduleId, timeSlot: timeSlot, type: type)
//    }
}
