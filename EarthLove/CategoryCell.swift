//
//  CategoryCell.swift
//  EarthLove
//
//  Created by Seth Watson on 1/28/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

