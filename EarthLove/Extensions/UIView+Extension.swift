//
//  UIView+Extension.swift
//  EarthLove
//
//  Created by Suke Watson on 3/9/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

extension UIView {
    func pinFrameToSuperView() {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false

        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
    }
}
