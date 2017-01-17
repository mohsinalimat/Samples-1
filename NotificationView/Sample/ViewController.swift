//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/16/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            NotificationView.show(title: "Trending feed shows you which events have been\nStarred the most in your city! Be sure to check\nout which of your friends are interested!", subtitle: "Okay, cool.", backgroundColor: .red, hideAfter: 7)
        }
    }
    
}

