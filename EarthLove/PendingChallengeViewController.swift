//
//  PendingChallengeViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 12/16/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class PendingChallengeViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatCountdownLabel()
        
        
    }
    func determineTimeRemaining() -> String? {
        guard let twentyFourHours = secondsInTwentyFourHours else { return nil }
        guard let challengeCreationTime = challengeCreationTime else { return nil }
        let time = (twentyFourHours - abs(challengeCreationTime.timeIntervalSinceNow))
        
        let hours = Int(time / secondsInAnHour)
        let minutes = Int(time / 60) % 60
        let seconds = Int(time) % 60
        
        return ("Hours: \(hours) Minutes: \(minutes) Seconds: \(seconds)")
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var countdownLabel: UILabel!
    
    func formatCountdownLabel() {
        guard let timeRemaining = determineTimeRemaining() else { return }
        countdownLabel.text = String(timeRemaining)
    }
    
}
