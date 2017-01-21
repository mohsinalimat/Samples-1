//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/20/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var playerView: PlayerView {
        return self.view as! PlayerView
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = PlayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.url = URL(string: "https://v.cdn.vine.co/r/videos/AA3C120C521177175800441692160_38f2cbd1ffb.1.5.13763579289575020226.mp4")
        playerView.loop = true
        playerView.playFromBeginning()
    }

}

