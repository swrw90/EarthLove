//
//  PendingChallengeTimerView.swift
//  EarthLove
//
//  Created by Seth Watson on 3/9/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

/// Contains handleCountdownEnding function to update app after pending challenge timer reaches 0.0
protocol PendingChallengeTimerViewDelegate: AnyObject {
    func handleCountdownEnding()
}

/// UIView to display countdown until the next challenge is available.
class PendingChallengeTimerView: UIView {
    
    
    // MARK: - Properties
    
    var timer: Timer?
    var secondsInTwentyFourHours: TimeInterval?
    var challengeCreationTime: Date?
    var remainingTimeInSeconds: Double?
    let secondsInAnHour: Double = 3600
    
    weak var delegate: PendingChallengeTimerViewDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var countdownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        runChallengeTimer()
    }
    
    // Creates an instance of PendingChallengeTimerView nib.
    class func instanceOfPendingChallengeTimerViewNib() -> UIView {
        return UINib(nibName: "PendingChallengeTimerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    
    /// Starts timer countdown until next challenge is available.
    private func runChallengeTimer()  {
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    ///  Sets values for the pending challenge timer and returns them in a formatted string.
    private func formatTime() -> String? {
        guard let twentyFourHours = secondsInTwentyFourHours, let challengeCreationTime = challengeCreationTime else { return nil }
        let remainingTimeInSeconds = (twentyFourHours - abs(challengeCreationTime.timeIntervalSinceNow))
        self.remainingTimeInSeconds = remainingTimeInSeconds
        
        let hours = Int(remainingTimeInSeconds / secondsInAnHour)
        let minutes = Int(remainingTimeInSeconds / 60) % 60
        let seconds = Int(remainingTimeInSeconds) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
    }
    
    /// Assigns formatted countdown time remaining to PendingChallengeVC countdown label.
    @objc private func updateTimer() {
        countdownLabel.text = formatTime()
        guard let remainingTimeInSeconds = remainingTimeInSeconds else { return }
        if remainingTimeInSeconds < 0.0 {
            timer?.invalidate()
            delegate?.handleCountdownEnding()
            
        }
    }
    
}
