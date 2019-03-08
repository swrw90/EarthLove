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
    var fortuneView: FortuneView?
    let challengeIdentifierKey = "identifier"
    let creationTimeKey = "creationTime"
    let skipTimeStampKey = "skipTimeStamp"
    let skipCountKey = "skipCount"
    let numberOfTimesCompletedKey = "numberOfTimesCompleted"
    let countUntilFortuneDisplaysKey = "countUntilFortuneDisplays"
    let showPendingViewControllerKey = "showPendingViewController" 
    let secondsInTwentyFourHours: TimeInterval = 60 * 60 * 24
    
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
    @IBOutlet weak var returnToHistoryVCButton: UIButton!
    
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // Display completedChallenge for Challenge selected in HistoryVC.
    class func displayCompletedChallenge(with: Challenge?) {
        
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
        returnToHistoryVCButton.isHidden = false
        
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        categoryImageView.image = challenge.category.iconImage
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
    
    @IBAction func dismissChallengeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Update skip button after a challenge is completed.
    private func updateSkipButton() {
        skipButton.isOpaque = challenge?.isCompleted == true
        skipButton.isEnabled = challenge?.isCompleted == false
    }
    
    // Handle completed button press.
    @IBAction private func completedPressed(_ sender: UIButton) {
        numberOfTimesCompleted += 1
        countUntilFortuneDisplays += 1
        
        if countUntilFortuneDisplays == 7 {
            handleCountUntilFortuneDisplays()
        }
        
        performSegue(withIdentifier: showPendingViewControllerKey, sender: nil)
        updateSkipButton()
        changeCompletionStatus()
        
    }
    
    // Displays random Fortune after count to display fortune is 7, resets count to 0.
    private func handleCountUntilFortuneDisplays() {
            displayRandomFortune()
            countUntilFortuneDisplays = 0
    }
    
    // Display random fortune's data.
    private func displayRandomFortune() {
        
        guard fortuneView == nil else { return }
        
        guard let context = managedObjectContext else { return }
        guard let fortune = Fortune.getRandomFortune(in: context), let summary = fortune.summary else { return }
        guard let fortuneView = FortuneView.instanceOfFortuneNib() as? FortuneView else { return }
        
        self.fortuneView = fortuneView
        
        // Add subview to top level view.
        self.view.addSubview(fortuneView)
        fortuneView.fortuneLabel.text = summary
        
        UIView.animate(withDuration: 0.3, animations: {
            fortuneView.frame.origin.y = self.view.frame.height / 2
        })
    }
    
    
    //MARK: - Navigation
    
    // Prepares PendingChallengeVC by passing necessary data during segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showPendingViewControllerKey {
            guard let controller = segue.destination as? PendingChallengeViewController else { return }
            controller.secondsInTwentyFourHours = secondsInTwentyFourHours
            controller.challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date
        }
    }
}
