//
//  ViewController.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/15/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UITableViewController, DatabaseControllerDelegate {
    
    let backgroundView = UIImageView()
    
    var notes = [Note]()
    private var listener: ListenerRegistration?
    
    func getNotesDbCollection() -> CollectionReference? {
        if let user = Auth.auth().currentUser {
            let query = Firestore.firestore().collection("Users").document(user.email!).collection("Notes")
            return query
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

         backgroundView.image = UIImage(named: "Memo")!
         backgroundView.contentMode = .scaleAspectFit
         backgroundView.alpha = 0.5
         tableView.backgroundView = backgroundView
         tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeQuery()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if user == nil {
            print("User is not registered")
            self.presentLoggedInScreen()
        }
        else {
            print("User registered - \(user?.email ?? "User not found")")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    fileprivate func observeQuery() {
        stopObserving()
        if let query = self.getNotesDbCollection() {
            listener =  query.addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                self.notes.removeAll()
                for doc in snapshot.documents {
                    //let data = doc.data()
                    let id = doc.documentID
                    let text = doc["text"] as? String ?? ""
                    let date = doc["date"] as? Date
                    let note = Note(id: id, text: text, date: date)
                    self.notes.append(note)
                }
                
                if self.notes.count > 0 {
                    self.tableView.backgroundView = nil
                } else {
                    self.tableView.backgroundView = self.backgroundView
                }
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.text
        
        var strDate = ""
        if note.date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "en_US")
            strDate = dateFormatter.string(from: note.date!)
        }
        cell.detailTextLabel?.text = strDate
        return cell
    }
    
    //Return button
    @IBAction func returnActionTapped(_ sender: UIBarButtonItem) {
        self.returnToBack()
    }
    
    // Add button
    @IBAction func addActionTapped(_ sender: UIBarButtonItem) {
        transition(isNewNote: true, updateNote: nil)
    }
    
    // Update touch
    override func tableView(_ tableView: UITableView, didSelectRowAt IndexPath: IndexPath) {
        let note = notes[IndexPath.row]
        if self.getNotesDbCollection() != nil {
            transition(isNewNote: false, updateNote: note)
        }
    }
    
    // Delete swipe left
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note = notes[indexPath.row]
        if let id = note.id {
            if let ref = self.getNotesDbCollection() {
                ref.document(id).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
        }
    }
    
    func returnToBack() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let returnBack: LoggedInVC = storyboard.instantiateViewController(withIdentifier: "LoggedInVC") as! LoggedInVC
        self.present(returnBack, animated: true, completion: nil)
    }
    
    func presentLoggedInScreen() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let todo: ViewControllerLoginScreen = storyboard.instantiateViewController(withIdentifier: "ViewControllerLoginScreen") as! ViewControllerLoginScreen
        self.present(todo, animated: true, completion: nil)
    }
    
    func saveNote(_ controller: EditNoteViewController, newNote note: Note) {
        self.getNotesDbCollection()?.addDocument(data: ["text" : note.text, "date" : FieldValue.serverTimestamp()])
    }
    
    func updateNote(_ controller: EditNoteViewController, updatedNote note: Note) {
        if let ref = self.getNotesDbCollection() {
            ref.document(note.id!).setData(["text" : note.text, "date" : FieldValue.serverTimestamp()]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
    }
    
    func transition(isNewNote: Bool, updateNote: Note?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: EditNoteViewController = storyboard.instantiateViewController(withIdentifier: "EditNoteViewController") as! EditNoteViewController
        controller.delegate = self
        controller.isNewNote = isNewNote
        controller.updatedNote = updateNote
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

