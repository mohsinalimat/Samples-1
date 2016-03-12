//
//  AppDelegate.swift
//  Sample
//
//  Created by Lasha Efremidze on 3/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        swizzle()
        return true
    }
    
}

private extension AppDelegate {
    
    func swizzle() {
        let originalSelector = Selector("dealloc")
        let swizzledSelector = Selector("swizzled_dealloc")
        swizzleMethodSelector(originalSelector, swizzledSelector: swizzledSelector, forClass: UIViewController.self)
    }
    
}
