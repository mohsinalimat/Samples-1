//
//  ViewController.swift
//  ParallaxHeader
//
//  Created by Lasha Efremidze on 10/17/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var scrollView: ScrollView = { [unowned self] in
        let scrollView = ScrollView()
        scrollView.parallaxHeader.view = NSBundle.mainBundle().loadNibNamed("StarshipHeader", owner: self, options: nil)?.first as? UIView
        scrollView.parallaxHeader.height = 300
        scrollView.parallaxHeader.mode = .Fill
        scrollView.parallaxHeader.minimumHeight = 20
        self.view.addSubview(scrollView)
        scrollView.constrainToEdges()
        return scrollView
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.dataSource = self
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.frame
        scrollView.contentSize = frame.size
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        tableView.frame = frame
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = String(UITableViewCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(id) ?? UITableViewCell(style: .Default, reuseIdentifier: id)
        cell.textLabel?.text = String(format: "Row %ld", indexPath.row * 10)
        return cell
    }
    
}

private extension UIView {
    
    func constrainToEdges() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            self.topAnchor.constraintEqualToAnchor(self.superview!.topAnchor),
            self.leadingAnchor.constraintEqualToAnchor(self.superview!.leadingAnchor),
            self.bottomAnchor.constraintEqualToAnchor(self.superview!.bottomAnchor),
            self.trailingAnchor.constraintEqualToAnchor(self.superview!.trailingAnchor)
        ])
    }
    
}
