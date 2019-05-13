//
//  CreateScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class CreateScheduleController: UIViewController {
    
    var userProfessor = Professor()
    
    @IBOutlet weak var weekDaysTableView: UITableView!
    
    var weekDaysTitles = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchScheduleForUserProfessor()
        weekDaysTableView.delegate = self
        weekDaysTableView.dataSource = self
        
        weekDaysTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        weekDaysTableView.rowHeight = 45
        weekDaysTableView.isScrollEnabled = false
        weekDaysTableView.separatorStyle = .none
        
    }
    
    func fetchScheduleForUserProfessor() {
        var db = Firestore.firestore()
        let query = db.collection("Professors").whereField("profId", isEqualTo: userProfessor.profId)
        
        query.getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot result: \(error)")
                return
            }
            
            if snapshot.documents.count > 0 {
                for doc in snapshot.documents {
                    
                    if let model = Professor(dictionary: doc.data()) {
                        self.userProfessor = model
                    }  else {
                        print("Unable to initialize \(Professor.self) with document data \(doc.data())")
                    }
                    
                }
            }
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdateScheduleController" {
            guard let indexPath = weekDaysTableView.indexPathForSelectedRow else {return}
            if let destinationVC = segue.destination as? UpdateScheduleController {
                destinationVC.scheduleForDay = userProfessor.Schedule[weekDays[indexPath.row]] as! [String: Any]
            }
        }
    }
    

}

extension CreateScheduleController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = weekDaysTableView.dequeueReusableCell(withIdentifier: "ProfileInfoCell", for: indexPath) as! ProfileInfoCell
        cell.profileRowTitleLabel.text = weekDaysTitles[indexPath.row]
        cell.profileRowValueLabel.text = ""
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToUpdateScheduleController", sender: self)
    }
}
