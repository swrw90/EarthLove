//
//  FortuneMessageViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 2/27/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

/// Contains clearViewStack function to be called after fortuneMessageView is dismissed.
protocol FortuneMessageViewDelegate: class {
    func didTapDismiss(with messageView: FortuneMessageView)
}

/// UIView used to display the fortune message.
class FortuneMessageView: UIView {
    
    weak var delegate: FortuneMessageViewDelegate?
    var dismissButton = UIButton()
    
    // Dismisses fortune message view.
    private func setupDismissButton() {
        dismissButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        dismissButton.setBackgroundImage(UIImage(named: "diamond"), for: UIControl.State.normal)
        self.dismissButton.addTarget(self, action: #selector(dismissTapped(sender:)), for: .touchUpInside)
        self.addSubview(dismissButton)
    }
    
    override func awakeFromNib() {
        setupDismissButton()

    }
    
    
    // MARK: Properties
    
    @IBOutlet weak var fortuneLabel: UILabel!
    
    // Creates an instance of FortuneMessageView from nib.
    class func instanceOfFortuneNib() -> UIView {
        return UINib(nibName: "FortuneMessageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @objc func dismissTapped(sender: UIButton) {
        delegate?.didTapDismiss(with: self)
    }
}
