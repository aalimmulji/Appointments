//
//  ProfessorListController.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/8/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import UIKit
import Firebase

class ProfessorListController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var professorListTableView: UITableView!
    
    @IBOutlet weak var topNavigationBar: UINavigationItem!
    
    //MARK:- Global variable
    let db = Firestore.firestore()
    var professors: [Professor] = []
    var documents : [DocumentSnapshot] = []
    var student = Student()
    var userProfessor = Professor()
    var userType = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topNavigationBar.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        topNavigationBar.backBarButtonItem?.tintColor = UIColor.white
        professorListTableView.delegate = self
        professorListTableView.dataSource = self
        
        professorListTableView.register(UINib(nibName: "ProfessorCell", bundle: nil), forCellReuseIdentifier: "ProfessorCell")
        professorListTableView.allowsSelection = true
        professorListTableView.rowHeight = 246
        professorListTableView.backgroundColor = UIColor(colorWithHexValue: 0xF0F0F0)
        professorListTableView.separatorStyle = .none
        
        getProfessorListQuery()

    }
    
    //MARK:- Get Professor list Query
    func getProfessorListQuery() {
        db.collection("Professors").getDocuments { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshot result: \(error)")
                return
            }
            
            let models = snapshot.documents.map({ (document) -> Professor in
                
                print("Documents.data(): ", document.data())
                if let model = Professor(dictionary: document.data()) {
                    return model
                } else {
                    print("Unable to initialize \(Appointment.self) with document data \(document.data())")
                    return Professor()
                }
            })
            
            self.professors = models
            print("Professors: \n", self.professors)
            self.documents = snapshot.documents
            print("Documents: ", self.documents)
            self.professorListTableView.reloadData()
        }
    }
    
    //MARK:- Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfessorSchedule" {
            guard let indexPath = professorListTableView.indexPathForSelectedRow else {
                return
            }
            if let destinationVC = segue.destination as? CalendarKitMainController {
                destinationVC.professor = professors[indexPath.row]
                destinationVC.student = student
                destinationVC.userType = userType
                destinationVC.userProfessor = userProfessor
            }
        }
    }

}

extension ProfessorListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return professors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = professorListTableView.dequeueReusableCell(withIdentifier: "ProfessorCell", for: indexPath) as! ProfessorCell
        cell.professorNameLabel.text = "\(professors[indexPath.row].firstName) \(professors[indexPath.row].lastName), \(professors[indexPath.row].title)"
        cell.professorDesignationLabel.text = "\(professors[indexPath.row].designation)"
        
        let profPictureStorageRef = Storage.storage().reference().child("professor/\(professors[indexPath.row].profId).jpg")
        profPictureStorageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error downloading the image: \(error)")
            } else {
                let image = UIImage(data: data!)
                cell.pictureImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToProfessorSchedule", sender: self)
        professorListTableView.deselectRow(at: indexPath, animated: true)
        
    }
}
