//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

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
    let secondsInTwentyFourHours: TimeInterval = 24 * 60 * 60
    
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
    
    // If completed challenge is not nil setup selected challenge UI is called to update UI fro challenge selected in HistoryVC. Else, call displayChallenge.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let completedChallenge = completedChallenge {
            setupSelectedChallengeUI(with: completedChallenge)
        } else {
            displayChallenge()
        }
    }
    
    /// Checks if the challenge creation time has lapsed 24 hours.
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
    
    /// Handles if a new random challenge needs to display or else it fetch previously displayed challenge.
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
        self.titleLabel.text = challenge.title
        self.descriptionLabel.text = challenge.summary
        self.categoryImageView.image = challenge.category.iconImage
    }
    
    /// Setup UI for Challenge selected in HistoryVC
    private func setupSelectedChallengeUI(with challenge: Challenge) {
        completedButton.isHidden = true
        skipButton.isHidden = true
        
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        categoryImageView.image = challenge.category.iconImage
    }
    
    /// Creates an instance of PendingChallengeTimerView if challenge is completed and timer has not lapsed.
    func displayPendingChallengeTimerView() {
        guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64 else { return }
        
        guard let challenge = Challenge.fetch(with: id, in: context) else { return }
        
        if challenge.isCompleted && !hasTwentyFourHoursPassed {
            
            guard let pendingChallengeTimerView = PendingChallengeTimerView.instanceOfPendingChallengeTimerViewNib() as? PendingChallengeTimerView else { return }
            
            pendingChallengeTimerView.delegate = self
            pendingChallengeTimerView.secondsInTwentyFourHours = secondsInTwentyFourHours
            pendingChallengeTimerView.challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date
            
            self.pendingChallengeTimerView = pendingChallengeTimerView
            
            self.view.addSubview(pendingChallengeTimerView)
            pendingChallengeTimerView.pinFrameToSuperView()
            
        } else if challenge.isCompleted != true {
            return
        } else if challenge.isCompleted && hasTwentyFourHoursPassed {
            displayNewChallenge()
        }
    }
    
    
    // Schedule notification to appear after ends.
    func scheduleNotificationTimer() {

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Daily Challenge"
        content.body = "Your daily Earth Love challenge is now available!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondsInTwentyFourHours, repeats: false)
        let request = UNNotificationRequest(identifier: "ChallengeNotification", content: content, trigger: trigger)
        
        center.add(request)

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
    
    // Update skip button UI after a challenge is completed.
    private func updateSkipButton() {
        skipButton.isOpaque = challenge?.isCompleted == true
        skipButton.isEnabled = challenge?.isCompleted == false
    }
    
    /// Whenever completed button is pressed, countUntilFortuneDisplays increments, if countUntilFortuneDisplays equals 7 perform FortuneRequest network call, pendingChallengeTimerView displays, Challenge completion status updates, .
    @IBAction private func completedPressed(_ sender: UIButton) {
        numberOfTimesCompleted += 1
        countUntilFortuneDisplays = 7
        
        if countUntilFortuneDisplays == 7 {
            performFortuneNetworkRequest()
            countUntilFortuneDisplays = 0
        }
        
        displayPendingChallengeTimerView()
        
        updateSkipButton()
        changeCompletionStatus()
        scheduleNotificationTimer()
        
    }
    
    /// Performs network request to get a random fortune from api, if error then it calls displayRandomFortuneMessage.
    private func performFortuneNetworkRequest()  {
        networkRequest = FortuneRequest.getFortune() { fortuneMessage, error in
            guard error == nil else { print("Fortune network request failed. Random Fortune will be pulled from Core Data.");  self.displayRandomFortuneMessage(); return }
            
            self.fortuneMessage = fortuneMessage
            DispatchQueue.main.async {
                self.displayFortuneImage()
            }
        }
    }
    
    
    /// Creates an instance of FortuneMessageView, adds it to the view stack and displays a fortune message from CoreData.
    func displayRandomFortuneMessage() {
        
        guard fortuneMessageView == nil else { return }
        
        guard let context = managedObjectContext else { return }
        guard let fortune = Fortune.getRandomFortune(in: context), let summary = fortune.summary else { return }
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
    
    // Creates an instance of FortuneImageView and adds it to view stack.
    private func displayFortuneImage() {
        guard let fortuneImageView = FortuneImageView.instanceOfFortuneImageView() as? FortuneImageView else { return }
        
        fortuneImageView.delegate = self
        fortuneImageView.fortuneCookieImage.image = UIImage(named: "fortune-cookie-image")
        fortuneImageView.fortuneMessage = self.fortuneMessage
        
        self.view.addSubview(fortuneImageView)
        fortuneImageView.pinFrameToSuperView()
    }
    
}

/// Hanldes delegation methods for PendingChallengeTimerView.
extension ChallengeViewController: PendingChallengeTimerViewDelegate {
    
    // Removes pending challenge timer view from superview, sets its value to nil and calls display new challenge function.
    func handleCountdownEnding() {
        pendingChallengeTimerView?.removeFromSuperview()
        pendingChallengeTimerView = nil
        displayNewChallenge()
    }
}

/// Handles delegation methods for FortuneImageView and FortuneMessageView.
extension ChallengeViewController: FortuneImageViewDelegate, FortuneMessageViewDelegate {
    
    // Removes FortuneImageView and FortuneMessageView from view stack and calls displayPendingChallengeTimerView function.
    func clearViewStack() {
        
        for view in self.view.subviews where view is FortuneImageView || view is FortuneMessageView {
            view.removeFromSuperview()
        }
        fortuneMessageView = nil
        displayPendingChallengeTimerView()
    }
    
    //  Creates an instance of FortuneMessageView, animates it and adds it to view stack.
    func displayFortuneMessageView() {
        guard fortuneMessageView == nil else { return }
        
        guard let fortuneView = FortuneMessageView.instanceOfFortuneNib() as? FortuneMessageView else { return }
        
        fortuneView.delegate = self
        self.fortuneMessageView = fortuneView
        
        // Add subview to top level view.
        self.view.addSubview(fortuneView)
        fortuneView.fortuneLabel.text = fortuneMessage
        
        UIView.animate(withDuration: 0.3, animations: {
            fortuneView.frame.origin.y = self.view.frame.height / 2
        })
    }
    
    
}
