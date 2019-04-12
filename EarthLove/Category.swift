//
//  Category.swift
//  EarthLove
//
//  Created by Seth Watson on 1/5/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

/// Enum to represent each case for the separate categories and their associated icon image. 
enum Category: String, CaseIterable {
    case work
    case home
    case recreational
    case volunteer
    
    var iconImage: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
