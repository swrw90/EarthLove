//
//  FortuneView.swift
//  EarthLove
//
//  Created by Seth Watson on 3/26/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

// Contains protocol methods for FortuneView.
protocol FortuneViewDelegate: class {
    
    func displayFortuneMessageView()
    
}

/// Contains methods and properties for FortuneView.
class FortuneView: UIView {
    
    enum FortuneCookieState {
        case unopened
        case opened
    }
    
    private var fortuneCookieState: FortuneCookieState = .unopened
    
    private let impact = UIImpactFeedbackGenerator()
    
    // MARK: - Properties
    
    // Cancel Fortune network request after completion.
    private var networkRequest: URLSessionDataTask? {
        willSet {
            networkRequest?.cancel()
        }
    }
    
    weak var delegate: FortuneViewDelegate?
    
    @IBOutlet weak var fortuneCookieImage: UIImageView!
    @IBOutlet weak var congratulatoryMessageTextView: UITextView!
    
    var fortuneMessage: String?
    var fortuneMessageView: FortuneMessageView?
    var numberOfTapsCount = 0
    
    // Adds tapGestureRecognizer to fortuneCookieImage.
    override func awakeFromNib() {
        super.awakeFromNib()
    
        backgroundColor = .none
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fortuneImageTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        fortuneCookieImage.addGestureRecognizer(tapGestureRecognizer)
        configureCookieImage()
    }
    
    private func configureCookieImage() {
        fortuneCookieImage.backgroundColor = UIColor.init(red: 246.0/255.0, green: 217.0/255.0, blue: 178.0/255.0, alpha: 1.0)
        fortuneCookieImage.layer.cornerRadius = fortuneCookieImage.frame.width / 2
        
        fortuneCookieImage.layer.shadowColor = UIColor.black.cgColor
        fortuneCookieImage.layer.shadowOpacity = 1.0
        fortuneCookieImage.layer.shadowOffset = CGSize(width: -1, height: 1)
        fortuneCookieImage.layer.shadowRadius = 5
    }
    
    // Returns an instance of UINib named FortuneView.
    class func instanceOfFortuneView() -> UIView {
        return UINib(nibName: "FortuneView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    /// Increments numberOfTapsCount each time user taps image.
    @objc func fortuneImageTapped(_ sender: UITapGestureRecognizer) {
        impact.impactOccurred()
        numberOfTapsCount += 1
        
        switch fortuneCookieState {
        case .unopened:
            fortuneCookieImage.image = UIImage(imageName: .openedFortuneCookie)
            fortuneCookieState = .opened
        case .opened:
            numberOfTapsCount = 0
            delegate?.displayFortuneMessageView()
            fortuneCookieImage.removeFromSuperview()
            congratulatoryMessageTextView.removeFromSuperview()
        }

    }
}
