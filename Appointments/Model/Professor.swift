//
//  Professor.swift
//  Appointments
//
//  Created by Aalim Mulji on 4/10/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation
import Firebase

struct Professor {
    
    var profId: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var emailId: String = ""
    var title: String = ""
    var dept: String = ""
    var designation: String = ""
    var Schedule: Dictionary<String,Any> = [String: Any]()
    
    var dictionary: [String : Any] {
        return [
            "profId": profId,
            "firstName": firstName,
            "lastName": lastName,
            "emailId": emailId,
            "title": title,
            "dept": dept,
            "designation": designation,
            "Schedule": Schedule
        ]
    }
}

extension Professor: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let profId = dictionary["profId"] as? String,
            let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let emailId = dictionary["emailId"] as? String,
            let title = dictionary["title"] as? String,
            let dept = dictionary["dept"] as? String,
            let designation = dictionary["designation"] as? String,
            let Schedule = dictionary["Schedule"] as? [String: Any] else { return nil }
        
        self.init(profId: profId,
                  firstName: firstName,
                  lastName: lastName,
                  emailId: emailId,
                  title: title,
                  dept: dept,
                  designation: designation,
                  Schedule: Schedule)
    }
}

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}
