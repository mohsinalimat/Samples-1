//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/17/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let transition = CustomTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = .yellowColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Helpers
extension ViewController {
    
    @IBAction func present(_: AnyObject) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("TableViewControllerId")
        let navigationController = UINavigationController(rootViewController: viewController!)
        navigationController.transitioningDelegate = transition
        navigationController.modalPresentationStyle = .Custom
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
}

