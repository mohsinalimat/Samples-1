//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/18/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func tapped(_: UIButton) {
        let viewController = ViewController2.make()
        viewController.completion = { [unowned self, unowned viewController2 = viewController] in
            let viewController = ViewController2.make()
            viewController.completion = {
                self.dismiss(animated: true, completion: nil)
            }
            let transition = CATransition()
            transition.duration = 0.3
            transition.type = kCATransitionFade
            viewController2.navigationController?.view.layer.add(transition, forKey: nil)
            viewController2.navigationController?.pushViewController(viewController, animated: false)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

class ViewController2: UIViewController {
    
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .random()
    }
    
    @IBAction func tapped(_: UIButton) {
        completion?()
    }
    
    class func make() -> ViewController2 {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! ViewController2
    }
    
}

extension UIColor {
    
    static func random() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}
