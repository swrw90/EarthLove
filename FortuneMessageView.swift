//
//  FortuneMessageViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 2/27/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

class FortuneMessageView: UIView {
    
    var dismissButton = UIButton()
    
    private func setupDismissButton() {
        dismissButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        dismissButton.setBackgroundImage(UIImage(named: "first"), for: UIControl.State.normal)
        self.dismissButton.addTarget(self, action: #selector(dismissFortuneView(sender:)), for: .touchUpInside)
        self.addSubview(dismissButton)
    }
    
    override func awakeFromNib() {
        setupDismissButton()

    }
    
    
    // MARK: Properties
    
    @IBOutlet weak var fortuneLabel: UILabel!
    
    class func instanceOfFortuneNib() -> UIView {
        return UINib(nibName: "FortuneMessageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @objc func dismissFortuneView(sender: UIButton) {
        self.removeFromSuperview()
        
    }
    
}
