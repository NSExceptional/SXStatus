//
//  Decoding+Status.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/12/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation
import JSON

func decode(_ dictionary: JSONDictionary, keyPath: String) throws -> Status {
    let string: String = try decode(dictionary, keyPath: keyPath)
    
    guard let status = Status(rawValue: string) else {
        throw JSONDeserializationError.invalidAttribute(key: keyPath)
    }
    
    return status
}
