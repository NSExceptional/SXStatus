//
//  Data+FromFile.swift
//  SXStatus
//
//  Created by Mark Malstrom on 3/18/17.
//  Copyright © 2017 Tangaroa. All rights reserved.
//

import Foundation

extension Data {
    init(fromFile: String, ofType: String) throws {
        let filePath = Bundle.main.path(forResource: fromFile, ofType: ofType)
        let fileURL = URL(fileURLWithPath: filePath!)
        try self.init(contentsOf: fileURL)
    }
}
