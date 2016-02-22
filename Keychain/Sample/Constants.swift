//
//  Constants.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/21/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import Foundation

protocol EnumCustomStringConvertible {
    var description: String { get }
}

extension EnumCustomStringConvertible {
    var description: String { return String(reflecting: self) }
}

enum Constants {
    enum Keychain: String, EnumCustomStringConvertible {
        case UUID
    }
}
