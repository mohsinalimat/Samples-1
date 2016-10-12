//
//  ViewController.swift
//  FlipAnimation
//
//  Created by Lasha Efremidze on 10/11/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flipView: FlipView! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        flipView.animate(toString: "0") { 
            self.flipView.animate(toString: "1") {
                self.flipView.animate(toString: "2") {
                    
                }
            }
        }
    }
    
}
