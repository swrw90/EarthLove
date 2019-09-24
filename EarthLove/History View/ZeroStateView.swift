//
//  ZeroStateView.swift
//  EarthLove
//
//  Created by Seth Watson on 4/14/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

/// Displayed to indicate to user that they have not completed any challenges yet.
class ZeroStateView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Creates an instance of ZeroStateView nib.
    class func instanceOfZeroStateViewNib() -> ZeroStateView {
        return UINib(nibName: "ZeroStateView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ZeroStateView
    }
    
}
