//
//  Device.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/21/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import Foundation
import KeychainAccess

struct Device {
    var UUID: String? {
        print(Constants.Keychain.UUID.description)
        
//        let UUIDString = Keychain.keychain[Constants.Keychain.UUID.description]
//        if let UUIDString = UUIDString {
//            
//        } else {
//            
//        }
        return UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
}

private extension Keychain {
    static let keychain = Keychain()
}

private extension NSBundle {
    var name: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}

private enum Constants {
    enum Keychain: String, CustomStringConvertible {
        case UUID
    }
}

private extension CustomStringConvertible {
    var description: String { return String(reflecting: self) }
}
