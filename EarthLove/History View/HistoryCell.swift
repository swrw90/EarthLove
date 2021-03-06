//
//  HistoryCell.swift
//  EarthLove
//
//  Created by Seth Watson on 11/25/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

/// Handles properties and UI update for HistoryCell nib when it is selected. 
class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 140/255, blue: 60/255, alpha: 0.5)
        selectedBackgroundView = selectedView
        
        accessoryType = .disclosureIndicator
    }
}
