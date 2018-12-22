//
//  PendingChallengeViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 12/16/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class PendingChallengeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var timer = Timer()
    var secondsInTwentyFourHours: TimeInterval?
    var challengeCreationTime: Date?
    var countdownDate = Date()
    let secondsInAnHour: Double = 3600
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    
    //    MARK: - Outlets
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runChallengeTimer()
        
    }
    
    /// Starts timer countdown until next challenge is available.
    func runChallengeTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    ///  Sets values for the pending challenge timer and returns them in a formatted string. 
    func formatTime() -> String? {
        guard let twentyFourHours = secondsInTwentyFourHours else { return nil }
        guard let challengeCreationTime = challengeCreationTime else { return nil }
        let time = (twentyFourHours - abs(challengeCreationTime.timeIntervalSinceNow))
        
        let hours = Int(time / secondsInAnHour)
        let minutes = Int(time / 60) % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
    }
    
    /// Assigns timeRemaining to PendingChallengeVC countdown label.
    @objc func updateTimer() {
        guard let timeRemaining = formatTime() else { return }
        countdownLabel.text = timeRemaining
    }
    
    
    //    MARK: - Actions
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        
        // Stops timer.
        timer.invalidate()
    }
    
}
