//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

/// Handles displaying Challenge object, skiping and completing Challenges.
class ChallengeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    var completedChallenge: Challenge?
    var fortuneMessageView: FortuneMessageView?
    var fortuneMessage: String?
    var pendingChallengeTimerView: PendingChallengeTimerView?
    let challengeIdentifierKey = "identifier"
    let creationTimeKey = "creationTime"
    let skipTimeStampKey = "skipTimeStamp"
    let skipCountKey = "skipCount"
    let numberOfTimesCompletedKey = "numberOfTimesCompleted"
    let countUntilFortuneDisplaysKey = "countUntilFortuneDisplays"
    let showPendingViewControllerKey = "showPendingViewController" 
    let secondsInTwentyFourHours: TimeInterval = 60
    
    // Watches for challenge value to change.
    private var challenge: Challenge? {
        didSet {
            // 1. Check if old Challenge is not the same as new Challenge.
            guard oldValue != challenge else { return }
            
            // 2. Set UserDefaults to store new Challenge id.
            if let challenge = challenge {
                UserDefaults.standard.set(challenge.identifier, forKey: challengeIdentifierKey)
                
                // 3. Update UI.
                setupChallengeUI(with: challenge)
            }
        }
    }
    
    
    // Cancel Fortune network request after completion.
    private var networkRequest: URLSessionDataTask? {
        willSet {
            networkRequest?.cancel()
        }
    }
    
    // Returns value of skip count from UserDefaults.
    var skipCount: Int {
        get {
            guard let skipCount = UserDefaults.standard.value(forKey: skipCountKey) as? Int else { fatalError("Skip count is nil.") }
            return skipCount
        }
        set {
            UserDefaults.standard.set(newValue, forKey: skipCountKey)
        }
    }
    
    // Returns value of numberOfTimesCompleted count from UserDefaults.
    var numberOfTimesCompleted: Int {
        get {
            guard let numberOfTimesCompleted = UserDefaults.standard.value(forKey: numberOfTimesCompletedKey) as? Int else { fatalError("Number of times completed count is nil.") }
            return numberOfTimesCompleted
        }
        set {
            UserDefaults.standard.set(newValue, forKey: numberOfTimesCompletedKey)
        }
    }
    
    // Returns value of countUntilFortuneDisplays count from UserDefaults.
    var countUntilFortuneDisplays: Int {
        get {
            guard let countUntilFortuneDisplays = UserDefaults.standard.value(forKey: countUntilFortuneDisplaysKey) as? Int else { fatalError("Count until Fortune Displays is nil.") }
            return countUntilFortuneDisplays
        }
        set {
            UserDefaults.standard.set(newValue, forKey: countUntilFortuneDisplaysKey)
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPendingChallengeTimerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let completedChallenge = completedChallenge {
            setupSelectedChallengeUI(with: completedChallenge)
        } else {
            displayChallenge()
        }
    }
    
    /// Checks if the creation time has lapsed 24 hours.
    private var hasTwentyFourHoursPassed: Bool {
        guard let challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date else { return false }
        return abs(challengeCreationTime.timeIntervalSinceNow) > secondsInTwentyFourHours
    }
    
    /// Returns a new random Challenge and updates the challenge creation time in UserDefaults.
    private func displayNewChallenge() {
        guard let context = managedObjectContext, let challenge = Challenge.fetchRandomChallenge(from: context) else { return }
        UserDefaults.standard.set(Date(), forKey: creationTimeKey)
        self.challenge = challenge
    }
    
    /// Handles if it needs to display a new random challenge or fetch previously displayed challenge.
    private func displayChallenge() {
        if hasTwentyFourHoursPassed {
            displayNewChallenge()
            skipCount = 0
        } else {
            guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64 else { return }
            challenge = Challenge.fetch(with: id, in: context)
            updateSkipButton()
        }
    }
    
    /// Configure ChallengeVC UI using Challenge object.
    private func setupChallengeUI(with challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        categoryImageView.image = challenge.category.iconImage
    }
    
    /// Setup UI for Challenge selected in HistoryVC
    private func setupSelectedChallengeUI(with challenge: Challenge) {
        completedButton.isHidden = true
        skipButton.isHidden = true
        
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        categoryImageView.image = challenge.category.iconImage
    }
    
    /// Displays PendingChallengeTimerView if challenge is completed and timer has not lapsed.
    func displayPendingChallengeTimerView() {
        guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64 else { return }
        
        guard let challenge = Challenge.fetch(with: id, in: context) else { return }
        
        if challenge.isCompleted && !hasTwentyFourHoursPassed {
            
            guard let pendingChallengeTimerView = PendingChallengeTimerView.instanceOfPendingChallengeTimerViewNib() as? PendingChallengeTimerView else { return }
            
            pendingChallengeTimerView.secondsInTwentyFourHours = secondsInTwentyFourHours
            pendingChallengeTimerView.challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date
            
            self.view.addSubview(pendingChallengeTimerView)
            pendingChallengeTimerView.pinFrameToSuperView()
            
        } else if challenge.isCompleted != true {
            return
        } else if challenge.isCompleted && hasTwentyFourHoursPassed {
            displayNewChallenge()
        }
    }
    
    
    /// Changes the isCompleted of a challenge with the specified id.
    private func changeCompletionStatus() {
        guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64, let challenge = Challenge.fetch(with: id, in: context) else { return }
        challenge.isCompleted = true
        
        try? context.save()
    }
    
    /// Displays alerts on the fourth press of the skip button. Informs user no more skips until 24 hours passes.
    private func showSkipAlert() {
        let alert = UIAlertController(title: "Out of Skips", message: "You're out of skips for the next 24 hours. Try to complete the challenge!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Actions
    
    // Increment skip count, show alert if count is greater than 3, otherwise call displayNewChallenge.
    @IBAction func skipButton(_ sender: Any ) {
        skipCount += 1
        
        if skipCount > 3 {
            showSkipAlert()
        } else {
            displayNewChallenge()
        }
    }
    
    // Update skip button after a challenge is completed.
    private func updateSkipButton() {
        skipButton.isOpaque = challenge?.isCompleted == true
        skipButton.isEnabled = challenge?.isCompleted == false
    }
    
    /// Whenever completed button is pressed, countUntilFortuneDisplays increments, pendingChallengeTimerView displays, Challenge completion status updates, if countUntilFortuneDisplays equals 7 perform FortuneRequest network call, if network request fails pull Fortune from Core Data.
    @IBAction private func completedPressed(_ sender: UIButton) {
        numberOfTimesCompleted += 1
        countUntilFortuneDisplays = 7
        
        if countUntilFortuneDisplays == 7 {
            performFortuneNetworkRequest()
//            displayFortuneImage()
//            handleCountUntilFortuneDisplays()
            countUntilFortuneDisplays = 0
        }
        
        displayPendingChallengeTimerView()
        
        updateSkipButton()
        changeCompletionStatus()
        
    }
    
    // Displays random Fortune after count to display fortune is 7, resets count to 0.
    //    private func handleCountUntilFortuneDisplays() {
    //
    ////        let fortuneMessage = performFortuneNetworkRequest()
    //
    ////        displayFortuneImage(with: fortuneMessage)
    //
    //        countUntilFortuneDisplays = 0
    //    }
    
    
    private func performFortuneNetworkRequest()  {
        DispatchQueue.global(qos: .background).async {
            self.networkRequest = FortuneRequest.getFortune() { fortuneMessage, error in
                guard error == nil else { print("Fortune network request failed. Random Fortune will be pulled from Core Data.");  self.displayRandomFortuneMessage(); return }
                
                 self.fortuneMessage = fortuneMessage
                DispatchQueue.main.async {
                    self.displayFortuneImage()
                }
        }

           
            print(self.fortuneMessage)
            self.displayFortuneImage()
        }
    }
    
    
    /// Display random fortune message from core data.
    func displayRandomFortuneMessage() {
        
        guard fortuneMessageView == nil else { return }
        
        //        guard let context = managedObjectContext else { return }
        //        guard let fortune = Fortune.getRandomFortune(in: context), let summary = fortune.summary else { return }
        guard let fortuneView = FortuneMessageView.instanceOfFortuneNib() as? FortuneMessageView else { return }
        
        self.fortuneMessageView = fortuneView
        
        // Add subview to top level view.
        self.view.addSubview(fortuneView)
        //        fortuneView.fortuneLabel.text = summary
        fortuneView.fortuneLabel.text = self.fortuneMessage
        
        UIView.animate(withDuration: 0.3, animations: {
            fortuneView.frame.origin.y = self.view.frame.height / 2
        })
    }
    
    // Show FortuneImageView which displays an image of a fortune cookie and congratulates the user on completing a challenge
    private func displayFortuneImage() {
        guard let fortuneImageView = FortuneImageView.instanceOfFortuneImageView() as? FortuneImageView else { return }
        
        fortuneImageView.fortuneCookieImage.image = UIImage(named: "fortune-cookie-image")
        fortuneImageView.fortuneMessage = self.fortuneMessage
        
        self.view.addSubview(fortuneImageView)
        fortuneImageView.pinFrameToSuperView()
    }
}

extension ChallengeViewController: PendingChallengeTimerViewDelegate {
    
    func handleCountdownEnding() {
        pendingChallengeTimerView?.removeFromSuperview()
        pendingChallengeTimerView = nil
        displayNewChallenge()
    }
}


extension ChallengeViewController: FortuneMessageDelegate {
    func displayFortuneMessageView() {
        //          FortuneImageView.fortuneMessage =  self.fortuneMessage
    }
    
    
}
