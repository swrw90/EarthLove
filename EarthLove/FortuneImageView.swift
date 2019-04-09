//
//  FortuneImageView.swift
//  EarthLove
//
//  Created by Seth Watson on 3/26/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

protocol FortuneImageViewDelegate: class {

    func displayFortuneMessageView()
    
}


class FortuneImageView: UIView {
    
    // MARK: - Properties
    
    // Cancel Fortune network request after completion.
    private var networkRequest: URLSessionDataTask? {
        willSet {
            networkRequest?.cancel()
        }
    }
    
    weak var delegate: FortuneImageViewDelegate?
    
    @IBOutlet weak var fortuneCookieImage: UIImageView!
    var fortuneMessage: String?
    var fortuneMessageView: FortuneMessageView?
    var numberOfTapsCount = 0
    
    
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
        numberOfTapsCount += 1
        
        if numberOfTapsCount == 1 {
            fortuneCookieImage.image = UIImage(named: "open-fortune-cookie-image")
        } else if numberOfTapsCount == 2 {
            delegate?.displayFortuneMessageView()
//            fortuneCookieImage.removeFromSuperview()
        }
    }
    //
    //    private func displayFortuneMessageView() {
    //        guard fortuneMessageView == nil else { return }
    //
    //        guard let fortuneView = FortuneMessageView.instanceOfFortuneNib() as? FortuneMessageView else { return }
    //
    //        self.fortuneMessageView = fortuneView
    //
    //        // Add subview to top level view.
    //        self.addSubview(fortuneView)
    //        fortuneView.fortuneLabel.text = fortuneMessage
    //
    //        UIView.animate(withDuration: 0.3, animations: {
    //            fortuneView.frame.origin.y = self.frame.height / 2
    //        })
    //    }
}
