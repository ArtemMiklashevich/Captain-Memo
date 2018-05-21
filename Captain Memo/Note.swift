//
//  User.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/15/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import Foundation

struct Note: Codable {
    
    var id: String? = nil
    var text: String
    var date: Date?
    
    init(id: String?, text: String, date: Date?) {
        self.id = id
        self.text = text
        self.date = date
    }
}
