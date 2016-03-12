//
//  Swizzler.swift
//  Sample
//
//  Created by Lasha Efremidze on 3/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import Foundation

func swizzleClassMethodSelector(originalSelector: Selector, swizzledSelector: Selector, forClass: AnyClass) {
    guard let forClass = object_getClass(forClass) else { return }
    
    let originalMethod = class_getClassMethod(forClass, originalSelector)
    let swizzledMethod = class_getClassMethod(forClass, swizzledSelector)
    
    let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

func swizzleMethodSelector(originalSelector: Selector, swizzledSelector: Selector, forClass: AnyClass) {
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    
    let didAddMethod = class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
    
    if didAddMethod {
        class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
