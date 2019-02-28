//
//  FortuneViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 2/27/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

class FortuneView: UIView {
    
    // MARK: Properties
    
    @IBOutlet weak var fortuneLabel: UILabel!
    
    class func instanceOfFortuneNib() -> UIView {
        return UINib(nibName: "FortuneView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

