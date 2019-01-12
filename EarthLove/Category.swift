//
//  Category.swift
//  EarthLove
//
//  Created by Seth Watson on 1/5/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

enum Category: String {
    case work
    case home
    case recreational
    case volunteer
    
    var iconImage: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
