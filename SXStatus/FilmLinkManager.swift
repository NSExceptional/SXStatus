//
//  FilmLinkManager.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/13/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation
import JSON

struct FilmLinkManager {
    static let shared = FilmLinkManager()
    private init() {}
    
    private let filmsJSON = Bundle.main.path(forResource: "films", ofType: "json")!
    
    func createLink(completion: @escaping ([FilmLink]) -> Void) {
        let filmsJSONURL = URL(fileURLWithPath: filmsJSON)
        let filmsJSONData  = try! Data(contentsOf: filmsJSONURL)
        let filmsDictionary = try! JSONSerialization.jsonObject(with: filmsJSONData, options: []) as! [String : [JSONDictionary]]
        
        let filmsDictionaryArray = filmsDictionary.flatMap { $0.1 }
        let films = filmsDictionaryArray.map({ (film) -> FilmLink in
            return try! FilmLink(jsonRepresentation: film)
        })
        
        completion(films)
    }
    
}
