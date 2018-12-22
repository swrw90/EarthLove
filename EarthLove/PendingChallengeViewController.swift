//
//  PendingChallengeViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 12/16/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

/// Displays a countdown timer until the next challenge is available.
class PendingChallengeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var timer: Timer?
    var secondsInTwentyFourHours: TimeInterval?
    var challengeCreationTime: Date?
    let secondsInAnHour: Double = 3600
    
    
    //    MARK: - Outlets
    
    @IBOutlet private weak var countdownLabel: UILabel!
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runChallengeTimer()
        
    }
    
    /// Starts timer countdown until next challenge is available.
    private func runChallengeTimer()  {
        updateTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    ///  Sets values for the pending challenge timer and returns them in a formatted string. 
    private func formatTime() -> String? {
        guard let twentyFourHours = secondsInTwentyFourHours, let challengeCreationTime = challengeCreationTime else { return nil }
        let time = (twentyFourHours - abs(challengeCreationTime.timeIntervalSinceNow))
        
        let hours = Int(time / secondsInAnHour)
        let minutes = Int(time / 60) % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
    }
    
    /// Assigns timeRemaining to PendingChallengeVC countdown label.
    @objc private func updateTimer() {
        countdownLabel.text = formatTime()
    }
    
    
    //    MARK: - Actions
    
    @IBAction private func closePressed(_ sender: Any) {
        timer?.invalidate()
        dismiss(animated: true, completion: nil)
    }
}
