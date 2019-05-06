//
//  User.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/4/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation

struct User {
    
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var username : String = ""
    var major: String = ""
    var degreeLevel : String = ""
    var studentId : String = ""
    var profilePictureUrl : String = ""
    
    var dictionary : [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "username" : username,
            "major": major,
            "degreeLevel": degreeLevel,
            "studentId": studentId,
            "profilePictureUrl" : profilePictureUrl
        ]
    }
}

extension User : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String,
            let email = dictionary["email"] as? String,
            let username = dictionary["username"] as? String,
            let major = dictionary["major"] as? String,
            let degreeLevel = dictionary["degreeLevel"] as? String,
            let studentId = dictionary["studentId"] as? String,
            let profilePictureUrl = dictionary["profilePictureUrl"] as? String else { return nil }
        
        self.init(firstName: firstName,
                  lastName: lastName,
                  email: email,
                  username: username,
                  major: major,
                  degreeLevel: degreeLevel,
                  studentId: studentId,
                  profilePictureUrl: profilePictureUrl)
    }
}

