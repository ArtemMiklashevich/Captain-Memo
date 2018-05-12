//
//  ProtocolDelegate.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 5/11/18.
//  Copyright © 2018 Artem Miklashevych. All rights reserved.
//

import Foundation

protocol DatabaseControllerDelegate: NSObjectProtocol {
    func saveNote(_ controller: EditNoteViewController, newNote note: Note)
    func updateNote(_ controller: EditNoteViewController, updatedNote note: Note)
}
