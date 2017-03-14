//
//  Movie.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/12/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation
import JSON
import IGListKit

enum Status: String {
    case green = "go"
    case yellow = "hurry"
    case red = "full"
    
    var color: UIColor {
        switch self {
        case .green:
            return #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0.2784313725, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 0.9764705882, green: 0.6588235294, blue: 0.1450980392, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.7764705882, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        }
    }
}

class Event: JSONDeserializable {
    var venueName: String
    
    let status: Status
    let eventTime: String
    let eventName: String
    let position: Int
    private(set) var filmLink: FilmLink? = nil
    
    required init(jsonRepresentation: JSONDictionary) throws {
        if let link = jsonRepresentation["__filmLink"] as? FilmLink {
            self.filmLink = link
        }
        
        self.venueName = try decode(jsonRepresentation, keyPath: "value.venue_name")
        self.status = try decode(jsonRepresentation, keyPath: "value.status")
        self.eventTime = try decode(jsonRepresentation, keyPath: "value.event_time")
        self.eventName = try decode(jsonRepresentation, keyPath: "value.event_name")
        self.position = try decode(jsonRepresentation, keyPath: "value.position")
    }
    
    convenience init(jsonRepresentation: JSONDictionary, filmLink: FilmLink) throws {
        var json = jsonRepresentation
        json["__filmLink"] = filmLink
        try self.init(jsonRepresentation: json)
    }
    
}

extension Event: IGListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return (eventName + " : " + venueName) as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        guard let object = object as? Event else { return false }
        return self.eventName == object.eventName && self.venueName == object.venueName
    }
}

