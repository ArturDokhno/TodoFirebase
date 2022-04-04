//
//  LoginViewController.swift
//  TodoFirebase
//
//  Created by Артур Дохно on 02.04.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let segueIndentifier = "tasksSegue"
    
    @IBOutlet var warnLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(kbDidShow),
                         name: UIResponder.keyboardDidShowNotification,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(kbDidHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
        
        warnLabel.alpha = 0
        
        FirebaseAuth.Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIndentifier)!,
                                   sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let kbFrameSize = (userInfo[UIResponder
            .keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView)
            .contentSize = CGSize(
                width: self.view.bounds.size.width,
                height: self.view.bounds.size.height + kbFrameSize.height)
        
        (self.view as! UIScrollView)
            .scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                  left: 0,
                                                  bottom: kbFrameSize.height,
                                                  right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height)
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: [.curveEaseOut]) { [weak self] in
            self?.warnLabel.alpha = 1
        } completion: { [weak self] complete in
            self?.warnLabel.alpha = 0
        }
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        FirebaseAuth.Auth.auth().signIn(
            withEmail: email,
            password: password) { [weak self] (user, error) in
                if error != nil {
                    self?.displayWarningLabel(withText: "Error occured")
                    return
                }
                if user != nil {
                    self?.performSegue(withIdentifier:
                                        (self?.segueIndentifier)!,
                                       sender: nil)
                    return
                }
                self?.displayWarningLabel(withText: "No such user")
            }
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              email != "",
              password != "" else {
            displayWarningLabel(withText: "Info is incorrect")
            return
        }
        FirebaseAuth.Auth.auth().createUser(
            withEmail: email,
            password: password) { (user, error) in
                if error == nil {
                    if error != nil {
                        
                    } else {
                        print("User is not created")
                    }
                } else {
                    print(error!.localizedDescription)
                }
            }
    }
    
}

