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
        
        self.view.addGestureRecognizer(UITapGestureRecognizer { [unowned self] _ in
            self.showAlertController()
        })
    }
    
    func showAlertController() {
        let defaultAction = UIAlertAction(title: "Default", style: .default) { _ in
            NotificationView.show(state: .default)
        }
        let infoAction = UIAlertAction(title: "Info", style: .default) { _ in
            NotificationView.show(state: .info)
        }
        let successAction = UIAlertAction(title: "Success", style: .default) { _ in
            NotificationView.show(state: .success)
        }
        let warningAction = UIAlertAction(title: "Warning", style: .default) { _ in
            NotificationView.show(state: .warning)
        }
        let errorAction = UIAlertAction(title: "Error", style: .default) { _ in
            NotificationView.show(state: .error)
        }
        let colorAction = UIAlertAction(title: "Custom color", style: .default) { _ in
            let r = CGFloat(arc4random_uniform(256))
            let g = CGFloat(arc4random_uniform(256))
            let b = CGFloat(arc4random_uniform(256))
            let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
            NotificationView.show(state: .color(color))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: "Samples", message: "Select to show drop down message.", preferredStyle: .actionSheet)
        for action in [defaultAction, infoAction, successAction, warningAction, errorAction, colorAction, cancelAction] {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
}

private extension NotificationView {
    
    enum State {
        case `default`, info, success, warning, error, color(UIColor)
        
        var backgroundColor: UIColor {
            switch self {
            case .info: return UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 0.9)
            case .success: return UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 0.9)
            case .warning: return UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 0.9)
            case .error: return UIColor(red: 192/255.0, green: 57/255.0, blue: 43/255.0, alpha: 0.9)
            case .color(let color): return color
            default: return UIColor(red: 41/255.0, green: 128/255.0, blue: 185/255.0, alpha: 0.9)
            }
        }
    }
    
    class func show(state: State) {
        show(title: sampleText(), subtitle: "OK", backgroundColor: state.backgroundColor)
    }
    
    class func sampleText() -> String {
        let text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        let length = Int(arc4random_uniform(200)) + 10
        let end = text.characters.index(text.startIndex, offsetBy: length)
        return text.substring(with: (text.startIndex ..< end))
    }
    
}
