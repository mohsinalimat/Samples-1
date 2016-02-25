//
//  ApplicationCoordinator.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/24/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ApplicationCoordinator {
    
    var window: UIWindow
    
    var childCoordinators = [ApplicationCoordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
    }
    
}
