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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        fortuneCookieImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    class func instanceOfFortuneImageView() -> UIView {
        return UINib(nibName: "FortuneImageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // do something when image tapped
        print("image tapped")
        
        fortuneCookieImage.image = UIImage(named: "open-fortune-cookie-image")
    }
    
}
