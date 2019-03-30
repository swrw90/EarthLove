//
//  FortuneImageView.swift
//  EarthLove
//
//  Created by Seth Watson on 3/26/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

class FortuneImageView: UIView {
    
    
    // MARK: - Properties

    
    @IBOutlet weak var fortuneCookieImage: UIImageView!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
    }
    
    class func instanceOfFortuneImageView() -> UIView {
        return UINib(nibName: "FortuneImageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
}
