//
//  User.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/15/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? {get set}
}

struct Note: Codable, Identifiable {
    var id: String? = nil
    var text: String
   // var date: Date
    
    init(text: String/* ,date: Date*/) {
        self.text = text
     //   self.date = date
    }
}
