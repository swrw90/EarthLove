//
//  PendingChallengeViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 12/16/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class PendingChallengeViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runChallengeTimer()
    }
    
    func runChallengeTimer()  {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func formatTime() -> String? {
        guard let twentyFourHours = secondsInTwentyFourHours else { return nil }
        guard let challengeCreationTime = challengeCreationTime else { return nil }
        let time = (twentyFourHours - abs(challengeCreationTime.timeIntervalSinceNow))
        
        var hours = Int(time / secondsInAnHour)
        var minutes = Int(time / 60) % 60
        var seconds = Int(time) % 60
        seconds -= 1
        
        return ("\(hours): \(minutes): \(seconds)")
        
    }
    
    @objc func updateTimer() {
        guard let timeRemaining = formatTime() else { return }
        countdownLabel.text = timeRemaining
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var countdownLabel: UILabel!
    

    
}
