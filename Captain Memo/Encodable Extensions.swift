//
//  Encodable Extensions.swift
//  Captain Memo
//
//  Created by Artem Miklashevich on 12/20/17.
//  Copyright © 2017 Artem Miklashevych. All rights reserved.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String: Any] else { throw MyError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        return json
    }
}
