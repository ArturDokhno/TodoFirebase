//
//  TasksViewController.swift
//  TodoFirebase
//
//  Created by Артур Дохно on 02.04.2022.
//

import UIKit
import Firebase

class TasksViewController: UIViewController,
                           UITableViewDelegate,
                           UITableViewDataSource {
    
    var user: User!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    @IBOutlet var tavleView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else { return }
        user = User(user: currentUser)
        ref = Database.database()
            .reference(withPath: "users")
            .child(String(user.uid))
            .child("tasks")
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "New Task",
                                                message: "Add new task",
                                                preferredStyle: .alert)
        alertController.addTextField()
        
        let save = UIAlertAction(title: "Save",
                                 style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  textField.text != "" else { return }
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
    }
    
}

