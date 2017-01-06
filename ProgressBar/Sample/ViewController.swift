//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/4/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: ProgressView! {
        didSet {
            progressBar.backgroundColor = UIColor(white: 0.9, alpha: 1)
            progressBar.foregroundColor = UIColor(red: 0, green: 0.46, blue: 0.76, alpha: 1)
            progressBar.cornerRadius = progressBar.frame.height / 2
            progressBar.setProgress(0, animated: false)
        }
    }
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.trackTintColor = UIColor(white: 0.9, alpha: 1)
            progressView.progressTintColor = UIColor(red: 0, green: 0.46, blue: 0.76, alpha: 1)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.progressBar.setProgress(0.5, animated: true)
        }
    }
    
}
