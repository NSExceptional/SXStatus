//
//  FilmLink.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/13/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation
import JSON

struct FilmLink: JSONDeserializable {
    let name: String
    let url: URL
    
    private let id: Int
    
    init(jsonRepresentation: JSONDictionary) throws {
        self.name = try decode(jsonRepresentation, key: "name")
        self.id = try decode(jsonRepresentation, key: "id")
        self.url = URL(string: "http://schedule.sxsw.com/2017/films/\(self.id)")!
    }
}
