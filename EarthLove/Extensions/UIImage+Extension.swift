//
//  UIImage+Extension.swift
//  EarthLove
//
//  Created by Seth Watson on 9/4/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

/// Enum that contains all image name of the app. Use this in conjuction with UIImage extension `UIImage(imageName:)` to construct an image safely without using strings. 
public enum EarthLoveImageName: String {
    case checkmark
    case earthLoveIcon = "earth-love-icon"
    case first
    case closedFortuneCookie = "fortune-cookie-image"
    case heart
    case home
    case like
    case openedFortuneCookie = "open-fortune-cookie-image"
    case recreational
    case second
    case settings
    case share
    case thumbDown = "thumb-down"
    case volunteer
    case work
}

extension UIImage {
    
    /// Create an UIImage object with `EarthLoveImageName` See EarthLoveImageName Enum.
    ///
    /// - Parameter imageName: EarthLoveImageName type to be passed into to construct an UIImage.
    convenience init?(imageName: EarthLoveImageName) {
        self.init(named: imageName.rawValue)
    }
}
