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
    
    fileprivate func observeQuery() {
        stopObserving()
        
        if let query = self.getNotesDbCollection() {
            listener =  query.addSnapshotListener { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot results: \(error!)")
                    return
                }
                // self.notes = [Note]()
                self.notes.removeAll()
                do {
                    for document in snapshot.documents {
                        let note = try document.decode(as: Note.self)
                        self.notes.append(note)
                        print(note)
                    }
                } catch {
                    print(error)
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
        cell.detailTextLabel?.text =  "abc"//String(note.date)
        
        return cell
    }
    
    //RETURN BUTTON
    @IBAction func returnActionTapped(_ sender: UIBarButtonItem) {
        self.returnToBack()
    }
    
    // ADD BUTTON
    @IBAction func addActionTapped(_ sender: UIBarButtonItem) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: EditNoteViewController = storyboard.instantiateViewController(withIdentifier: "EditNoteViewController") as! EditNoteViewController
        controller.delegate = self
        controller.isNewNote = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Update
    override func tableView(_ tableView: UITableView, didSelectRowAt IndexPath: IndexPath) {
        let note = notes[IndexPath.row]
            if self.getNotesDbCollection() != nil {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller: EditNoteViewController = storyboard.instantiateViewController(withIdentifier: "EditNoteViewController") as! EditNoteViewController
                controller.delegate = self
                controller.isNewNote = false
                controller.updatedNote = note
                self.navigationController?.pushViewController(controller, animated: true)
            }
    }
    
    // Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note = notes[indexPath.row]
        do {
            guard let id = note.id else { throw MyError.encodingError }
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
        catch {
            print(error)
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
        self.getNotesDbCollection()?.addDocument(data: ["text" : note.text])
    }
    
    func updateNote(_ controller: EditNoteViewController, updatedNote note: Note) {
        if let ref = self.getNotesDbCollection() {
            ref.document(note.id!).setData(["text" : note.text]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
    }
    
}

