//
//  NotificationView2.swift
//  Sample
//
//  Created by Lasha Efremidze on 1/17/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

class NotificationView2: UIView {
    
    private lazy var verticalStackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        self.addSubview(stackView)
        stackView.constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: 8),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: 8),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor)
        ]}
        return stackView
    }()
    
    func add(_ view: UIView) {
        verticalStackView.addArrangedSubview(view)
    }
    
}
