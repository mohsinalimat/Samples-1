//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 6/14/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageControl: PageControl! {
        didSet {
            pageControl.sections = 4
            pageControl.pages = { _ in 4 }
            pageControl.pageIndicatorTintColor = .whiteColor()
            pageControl.currentPageIndicatorTintColor = .orangeColor()
        }
    }
    
}
