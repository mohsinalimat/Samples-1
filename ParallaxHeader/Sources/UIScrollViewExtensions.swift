//
//  UIScrollViewExtensions.swift
//  ParallaxHeader
//
//  Created by Lasha Efremidze on 10/24/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    var parallaxHeader: ParallaxHeader? {
        get { return _parallaxHeader }
        set {
            let oldValue = _parallaxHeader
            _parallaxHeader = newValue
            parallaxHeaderValueChanged(oldValue: oldValue, newValue: newValue)
        }
    }
    
}

// MARK: - Associated Object
private var parallaxHeaderKey: Void?

// MARK: - Private
private extension UIScrollView {
    
    var _parallaxHeader: ParallaxHeader? {
        get { return getAssociatedObject(&parallaxHeaderKey) }
        set { setAssociatedObject(&parallaxHeaderKey, newValue) }
    }
    
    func parallaxHeaderValueChanged(oldValue oldValue: ParallaxHeader?, newValue: ParallaxHeader?) {
        if oldValue == nil {
            if let newValue = newValue {
                addParallaxHeader(newValue)
            }
        } else if newValue == nil {
            if let oldValue = oldValue {
                removeParallaxHeader(oldValue)
            }
        }
    }
    
    func addParallaxHeader(view: ParallaxHeader) {
        if let tableView = self as? UITableView {
            tableView.tableHeaderView = view
        } else {
            self.addSubview(view)
        }
        self.sendSubviewToBack(view)
    }
    
    func removeParallaxHeader(view: ParallaxHeader) {
        if let tableView = self as? UITableView {
            tableView.tableHeaderView = nil
        } else {
            view.removeFromSuperview()
        }
    }
    
}

// MARK: - Associated Object Utils
private extension NSObject {
    
    func getAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    func setAssociatedObject<T: AnyObject>(key: UnsafePointer<Void>, _ value: T?) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
    
}
