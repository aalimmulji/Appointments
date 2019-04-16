//
//  Schedule.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/13/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation

struct ProfSchedule {
    
    var profId : String = ""
    var dayOfTheWeek : String = ""
    var isAvailableToday : Bool = false
    var schedule : [Schedule] = [Schedule]()
//
//    var dictionary : [String:Any] {
//        return [
//            "dayOfTheWeek": dayOfTheWeek,
//            "isAvailableToday": isAvailableToday,
//            "schedule": schedule
//        ]
//    }
//    
//}
//
//extension ProfSchedule: DocumentSerializable {
//    init?(dictionary: [String : Any]) {
//        
//        for everyValues in dictionary {
//            dayOfTheWeek = values.key
//            
//            if let availableToday = value.value["isAvailableToday"] as? Bool {
//                isAvailableToday = availableToday
//                
//                if isAvailableToday {
//                    
//                    if let sc = dictionary["schedule"] as? [String: Any] {
//                        schedule = sc
//                    }
//                }
//            }
//        }
//
//        self.init(profId: profId, dayOfTheWeek: dayOfTheWeek,
//                  isAvailableToday: isAvailableToday,
//                  schedule : schedule)
//    }

}
