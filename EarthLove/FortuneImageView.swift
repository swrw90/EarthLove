//
//  FortuneImageView.swift
//  EarthLove
//
//  Created by Seth Watson on 3/26/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit
//import SAConfettiView

// Contains protocol methods for FortuneImageView.
protocol FortuneImageViewDelegate: class {
    
    func displayFortuneMessageView()
    
}

/// Contains methods and properties for FortuneImageView.
class FortuneImageView: UIView {
    
    let impact = UIImpactFeedbackGenerator()
    
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
    
    // Adds tapGestureRecognizer to fortuneCookieImage.
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.backgroundColor = .none
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fortuneImageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        fortuneCookieImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        impact.impactOccurred()
//        numberOfTapsCount += 1
//
//        // If numberOfTapsCount is 1 update UIImage, if count is 2 reset count to 0, call displayFortuneMessageView and remove fortuneCookieImage from superview.
//        if numberOfTapsCount == 1 {
//            fortuneCookieImage.image = UIImage(named: "open-fortune-cookie-image")
//        } else if numberOfTapsCount == 2 {
//            numberOfTapsCount = 0
//            delegate?.displayFortuneMessageView()
//            fortuneCookieImage.removeFromSuperview()
//        }
//    }
    
    // Returns an instance of UINibe named FortuneImageView.
    class func instanceOfFortuneImageView() -> UIView {
        return UINib(nibName: "FortuneImageView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /// Increments numberOfTapsCount each time user taps image.
    @objc func fortuneImageTapped(_ sender: UITapGestureRecognizer) {
        impact.impactOccurred()
        numberOfTapsCount += 1
        
        // If numberOfTapsCount is 1 update UIImage, if count is 2 reset count to 0, call displayFortuneMessageView and remove fortuneCookieImage from superview.
        if numberOfTapsCount == 1 {
            fortuneCookieImage.image = UIImage(named: "open-fortune-cookie-image")
        } else if numberOfTapsCount == 2 {
            numberOfTapsCount = 0
            delegate?.displayFortuneMessageView()
            fortuneCookieImage.removeFromSuperview()
        }
    }
}
