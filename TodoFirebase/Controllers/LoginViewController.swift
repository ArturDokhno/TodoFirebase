//
//  LoginViewController.swift
//  TodoFirebase
//
//  Created by Артур Дохно on 02.04.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var warnLabel: UILabel!
    @IBOutlet var emailTextField: UIStackView!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbDidHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                          left: 0,
                                                                          bottom: kbFrameSize.height,
                                                                          right: 0)
    }
    
    @objc func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(
            width: self.view.bounds.size.width,
            height: self.view.bounds.size.height)
    }

    @IBAction func loginTapped(_ sender: Any) {
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
    }
    
}

