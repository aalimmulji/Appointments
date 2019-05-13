//
//  SideBarView.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/8/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case profile
    case help
    case logOut
    case none
    
    init(row: Int){
        switch row {
        case 1: self = .profile
        case 2: self = .help
        case 3: self = .logOut
        default: self = .none
        }
    }
}

class SideBarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
    var titleArray = [String]()
    
    weak var delegate: SidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        
        titleArray = ["Aalim Mulji", "Profile", "Help", "Log Out"]
        
        setupViews()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView = UIView()
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces = false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor = UIColor.clear
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            
            //            let crossButton = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
            //            crossButton.setTitle("x", for: .normal)
            //            crossButton.setTitleColor(UIColor.black, for: .normal)
            //            cell.addSubview(crossButton)
//            if let user = user {
//                if let url = URL(string: user.profilePicUrl) {
//                    getData(from: url) { data, response, error in
//                        guard let data = data, error == nil else { return }
//                        if let httpResponse = response as? HTTPURLResponse {
//                            if httpResponse.statusCode == 200 {
//                                print(response?.suggestedFilename ?? url.lastPathComponent)
//                                print("Download Finished")
//                                DispatchQueue.main.async() {
//                                    let cellImg: UIImageView!
//                                    cellImg = UIImageView(frame: CGRect(x: cell.frame.width/2-40, y: 20, width: 80, height: 80))
//                                    cellImg.layer.cornerRadius = 40
//                                    cellImg.layer.masksToBounds = true
//                                    cellImg.contentMode = .scaleAspectFill
//                                    cellImg.image = UIImage(data: data)
//                                    cell.addSubview(cellImg)
//                                }
//                            } else {
//                                DispatchQueue.main.async() {
//                                    let cellImg: UIImageView!
//                                    cellImg = UIImageView(frame: CGRect(x: cell.frame.width/2-40, y: 20, width: 80, height: 80))
//                                    cellImg.layer.cornerRadius = 40
//                                    cellImg.layer.masksToBounds = true
//                                    cellImg.contentMode = .scaleAspectFill
//                                    cellImg.image = #imageLiteral(resourceName: "logo_circle")
//                                    cell.addSubview(cellImg)
//
//                                    let initials = UILabel(frame: CGRect(x: cell.frame.width/2-25, y: 44, width: 50, height: 34))
//                                    cell.addSubview(initials)
//                                    var i = ""
//                                    if let user = self.user {
//                                        if user.firstName != "" {
//                                            i = i + user.firstName.prefix(1)
//                                        }
//                                        if user.lastName != "" {
//                                            i = i + user.lastName.prefix(1)
//                                        }
//                                    }
//                                    initials.text = i
//                                    initials.textAlignment = .center
//                                    initials.font = UIFont(name: "SFProText-Light", size: 24)
//                                    initials.textColor = UIColor(colorWithHexValue: 0x2C3E50)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
            
            let cellImg: UIImageView!
            cellImg = UIImageView(frame: CGRect(x: cell.frame.width/2-40, y: 20, width: 80, height: 80))
            cell.addSubview(cellImg)
            cellImg.layer.cornerRadius = 40
            cellImg.layer.masksToBounds = true
            cellImg.contentMode = .scaleAspectFit
            cellImg.image = UIImage(named: "profile_icon")
            if userType == "Student" {
                let imageStorageRef = Storage.storage().reference().child("student/\(student.username).jpg")
                imageStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading the image: \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        cellImg.image = image
                    }
                }
            } else {
                let imageStorageRef = Storage.storage().reference().child("professor/\(userProfessor.profId).jpg")
                imageStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    if let error = error {
                        print("Error downloading the image: \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        cellImg.image = image
                    }
                }
            }

//            let initials = UILabel(frame: CGRect(x: cell.frame.width/2-25, y: 44, width: 50, height: 34))
//            cell.addSubview(initials)
//            var i = ""
//
//            if user.firstName != "" {
//                i = i + user.firstName.prefix(1)
//            }
//            if user.lastName != "" {
//                i = i + user.lastName.prefix(1)
//            }
//            initials.text = i
//            initials.textAlignment = .center
//            initials.font = UIFont(name: "SFProText-Light", size: 24)
//            initials.textColor = UIColor(colorWithHexValue: 0x2C3E50)
            
            
            let cellLabel = UILabel(frame: CGRect(x: cell.frame.width/2-125, y: 120, width: 250, height: 30))
            cell.addSubview(cellLabel)
            cellLabel.textAlignment = .center
            cellLabel.font = UIFont(name: "SFProText-Regular", size: 17)
            cellLabel.textColor = UIColor(colorWithHexValue: 0x2C3E50)
            
            let cellLabelEmail = UILabel(frame: CGRect(x: cell.frame.width/2-125, y: 160, width: 250, height: 20))
            cell.addSubview(cellLabelEmail)
            
            cellLabelEmail.textAlignment = .center
            cellLabelEmail.font = UIFont(name: "SFProText-Regular", size: 12)
            cellLabelEmail.textColor = UIColor(colorWithHexValue: 0xECF0F1)
            
            if userType == "Student" {
                cellLabel.text = "\(student.firstName) \(student.lastName)"
                cellLabelEmail.text = student.emailId
            } else {
                cellLabel.text = "\(userProfessor.firstName) \(userProfessor.lastName)"
                cellLabelEmail.text = userProfessor.emailId
            }
            
            
        } else {
            
            let cellLabel = UILabel(frame: CGRect(x: 20, y: cell.frame.height/2-15, width: 250, height: 30))
            cell.addSubview(cellLabel)
            cellLabel.text = titleArray[indexPath.row]
            cellLabel.textColor = UIColor(colorWithHexValue: 0x2C3E50)
            cellLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cellLabel.font = UIFont(name: "SFProText-Regular", size: 17)
            cell.selectionStyle = .default
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 50
        }
    }
    
    func setupViews() {
        self.addSubview(myTableView)
        myTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    let myTableView : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


