//
//  CreateScheduleController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/12/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

protocol UpdateScheduleDelegate {
    func updateSchedule(updatedSchedule: [String: Any])
}

class CreateScheduleController: UIViewController {
    
    var userProfessor = Professor()
    
    @IBOutlet weak var weekDaysTableView: UITableView!
    
    var weekDaysTitles = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var weekDays = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"]
    
    var delegate : UpdateScheduleDelegate?
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        weekDaysTableView.delegate = self
        weekDaysTableView.dataSource = self
        
        weekDaysTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfoCell")
        weekDaysTableView.rowHeight = 45
        weekDaysTableView.isScrollEnabled = false
        weekDaysTableView.separatorStyle = .none
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdateScheduleController" {
            guard let indexPath = weekDaysTableView.indexPathForSelectedRow else {return}
            if let destinationVC = segue.destination as? UpdateScheduleController {
                destinationVC.scheduleForDay = userProfessor.Schedule[weekDays[indexPath.row]] as! [String: AnyObject]
                destinationVC.dayFull = weekDaysTitles[indexPath.row]
                destinationVC.dayShort = weekDays[indexPath.row]
                destinationVC.delegate = self
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        var db = Firestore.firestore()
        let query = db.collection("Professors").whereField("profId", isEqualTo: userProfessor.profId)
        query.getDocuments { (querySnapshot, error) in
            
            if let error = error {
                print("Error fetching snapshot result: \(error)")
            }
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot result: \(error)")
                return
            }
            
            print(snapshot.documents.count)
            if snapshot.documents.count > 0 {
                for doc in snapshot.documents {
                    doc.reference.setData(self.userProfessor.dictionary) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
            SVProgressHUD.dismiss()
        }
        delegate?.updateSchedule(updatedSchedule: userProfessor.Schedule)
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
        weekDaysTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CreateScheduleController: updateScheduleForDayDelegate {
    func updateScheduleForDay(schedule: [String : AnyObject], forDay: String) {
        userProfessor.Schedule[forDay] = schedule as [String : Any]
    }
}
