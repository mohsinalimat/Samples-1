//
//  Item.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/29/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

struct Item {
    let image: UIImage
    let title: String
    
    static func make() -> Item {
        return Item(image: Random.image, title: Random.text)
    }
}

private struct Random {
    
    static var image: UIImage {
        let width = (Int(arc4random_uniform(100)) + 100) * 2
        let height = (Int(arc4random_uniform(100)) + 100) * 2
        return URL(string: "https://unsplash.it/\(width)/\(height)/?random").map { try! Data(contentsOf: $0) }.flatMap { UIImage(data: $0) } ?? UIImage()
    }
    
    static var text: String {
        let text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        let length = Int(arc4random_uniform(100)) + 10
        let end = text.characters.index(text.startIndex, offsetBy: length)
        return text.substring(with: (text.startIndex ..< end))
    }
    
}
