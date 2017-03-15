//
//  Decoding+KeyPath.swift
//  JSON
//
//  Created by Mark Malstrom on 3/12/17.
//  Copyright © 2017 Sam Soffes. All rights reserved.
//

import Foundation
import JSON

/// Decode a key path value from a given JSON dictionary.
///
/// - parameter dictionary: a JSON dictionary
/// - parameter keyPath: the key path in the dictionary. Use dot notation to denote the key path.
/// - returns: The expected value
/// - throws: JSONDeserializationError
public func decode<T>(_ dictionary: JSONDictionary, keyPath: String) throws -> T {
	guard !keyPath.isEmpty else {
		throw JSONDeserializationError.invalidAttribute(key: keyPath)
	}
	
	var keys = keyPath.components(separatedBy: ".")
	let last = keys.popLast()!
	var current: JSONDictionary? = dictionary
	
	for key in keys {
		if let previous = current {
			current = previous[key] as? JSONDictionary
			
			if current == nil {
				throw JSONDeserializationError.missingAttribute(key: key)
			}
		}
	}
	
	guard let value = current?[last] else {
		throw JSONDeserializationError.missingAttribute(key: last)
	}
	
	if let attribute = value as? T, !(value is NSNull) {
		return attribute
	} else {
		throw JSONDeserializationError.invalidAttributeType(key: last, expectedType: T.self, receivedValue: value)
	}
}
