//
//  ViewControllerLoginScreen.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 2/8/18.
//  Copyright © 2018 Artem Miklashevych. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import Pastel
import Anchors

class ViewControllerLoginScreen: UIViewController {
    
    let pastel = PastelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(pastel, at: 0)
        activate(pastel.anchor.edges)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pastel.startAnimation()
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func logginTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let loginError = error {
                    self.createAlert(title: "ERROR", message: loginError.localizedDescription)
                    return
                }
                if (user != nil)
                {
                    self.gotoListScreen()
                }
            })
        }
    }
    
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let firebaseError = error {
                    self.createAlert(title: "ERROR", message: firebaseError.localizedDescription)
                    return
                }
                self.gotoListScreen()
            })
        }
    }
    
    func gotoListScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let todo: navigationToUserList = storyboard.instantiateViewController(withIdentifier: "navigationToUserList") as! navigationToUserList
        self.present(todo, animated: true, completion: nil)
    }
    
    func createAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
