//
//  UIDevice.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/21/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import KeychainAccess

extension UIDevice {
    
    var UUID: String? {
        let keychain = Keychain()
        var string = keychain[Constants.Keychain.UUID.description]
        if string == nil {
            string = UIDevice.currentDevice().identifierForVendor?.UUIDString
            keychain[Constants.Keychain.UUID.description] = string
        }
        return string
    }
    
}
