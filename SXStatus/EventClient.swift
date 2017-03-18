//
//  EventClient.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/18/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation
import JSON

struct EventClient {
    /// Singleton
    static let shared = EventClient()
    private init() { }
    
    private static let filmsJSONData = try! Data(fromFile: "films", ofType: "json")
    private static let exampleJSONData = try! Data(fromFile: "example_vsb", ofType: "json")
    
    /// A computed array of tuples of names and urls for each entry in films.json
    private static var links: [(name: String, url: URL)] {
        let filmsDictionary = try! JSONSerialization.jsonObject(with: EventClient.filmsJSONData, options: []) as! [String : [JSONDictionary]]
        let filmsDictionaryArray = filmsDictionary.flatMap { $0.1 }
        
        let films = filmsDictionaryArray.map({ (film) -> (name: String, url: URL) in
            let name: String = try! decode(film, key: "name")
            let id: String = try! decode(film, key: "id")
            return (name, URL(string: "http://schedule.sxsw.com/2017/films/\(id)")!)
        })
        
        return films
    }
    
    func getEvents(completion: @escaping ([Event]) -> Void) {
        let VSBURL = URL(string: "http://vsb.sxsw.com/api/_design/app/_view/venues")!
        
        var request = URLRequest(url: VSBURL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept" : "application/json"]
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                if let data = data, 200..<300 ~= statusCode {
                    
                    // Parse JSON, refresh view
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        let eventsJSON: [JSONDictionary] = try! JSON.decode(json as! JSONDictionary, key: "rows")
                        
                        /// An array of Event objects
                        let events = eventsJSON.flatMap({ (eventJSON) -> Event in
                            let name: String = try! decode(eventJSON, keyPath: "value.event_name")
                            
                            for link in EventClient.links {
                                if link.name == name {
                                    return try! Event(jsonRepresentation: eventJSON, url: link.url)
                                }
                            }
                            
                            return try! Event(jsonRepresentation: eventJSON, url: nil)
                            
                        })
                        
                        completion(events)
                    } else {
                        // FIXME: Display error to user
                        print("URL Session Task Failed: \(error!.localizedDescription)")
                    }
                }
            }
            else {
                // FIXME: Display error to user
                print("URL Session Task Failed: \(error!.localizedDescription)")
            }
        }).resume()
    }
    
    func getExampleEvents(completion: @escaping ([Event]) -> Void) {
        
    }
    
}
