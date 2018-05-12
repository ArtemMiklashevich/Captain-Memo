//
//  AlertService.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/15/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AlertService {
    
    private init() {}
    
    static func addNote(in vc: UIViewController, comletion: @escaping (Note) -> Void) {
       
        let alert = UIAlertController(title: "Add Note", message: nil, preferredStyle: .alert)
        alert.addTextField { (noteTF) in
            noteTF.placeholder = "note"
        }
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard let text = alert.textFields?.first?.text
            else { return }
            
            let note = Note(text: text)
            comletion(note)
        }
        
        alert.addAction(add)
        vc.present(alert, animated: true)
    }
    
    static func updateNote(_ note: Note, in vc: UIViewController, completion: @escaping (Note) -> Void) {
        let alert = UIAlertController(title: "Update \(note.text)", message: nil, preferredStyle: .alert)
        alert.addTextField { (textTF) in
            textTF.placeholder = "Text"
            textTF.text = note.text
        }
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            guard
                let textString = alert.textFields?.first?.text
                else { return }
            
            var updatedNote = note
            updatedNote.text = textString
            
            completion(updatedNote)
        }
        alert.addAction(update)
        vc.present(alert, animated: true)
    }
}


