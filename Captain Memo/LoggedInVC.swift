//
//  LoggedInVC.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 2/8/18.
//  Copyright © 2018 Artem Miklashevych. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoggedInVC: UIViewController {

    @IBAction func logoutTapped(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
           self.returnToLoginScreen()
        } catch {
            print("There was a problem logging out")
        }
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.returnToList()
    }
    
    func returnToList() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let returnBack: navigationToUserList = storyboard.instantiateViewController(withIdentifier: "navigationToUserList") as! navigationToUserList
        self.present(returnBack, animated: true, completion: nil)
    }
    
    func returnToLoginScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let returnBack: navigationToUserList = storyboard.instantiateViewController(withIdentifier: "navigationToUserList") as! navigationToUserList
         self.present(returnBack, animated: true, completion: nil)
    }
    
}
