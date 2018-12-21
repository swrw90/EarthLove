//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

// Handles displaying Challenge object, skiping and completing Challenges
class ChallengeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private var challenge: Challenge? {
        didSet {
            // 1. Check if old Challenge is not the same as new Challenge
            guard oldValue != challenge else { return }
            
            // 2. Set UserDefaults to store new Challenge id
            if let challenge = challenge {
                UserDefaults.standard.set(challenge.identifier, forKey: challengeIdentifierKey)
                
                // 3. Update UI
                setupChallengeUI(with: challenge)
            }
        }
    }
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    var managedObjectContext: NSManagedObjectContext?
    let challengeIdentifierKey = "identifier"
    let creationTimeKey = "creationTime"
    let skipTimeStampKey = "skipTimeStamp"
    let skipCountKey = "skipCount"
    
    var skipCount: Int {
        get {
            guard let skipCount = UserDefaults.standard.value(forKey: skipCountKey) as? Int else { fatalError("Somethings messed up with count") }
            return skipCount
        }
        set {
            UserDefaults.standard.set(newValue, forKey: skipCountKey)
        }
    }
    
    let secondsInTwentyFourHours: TimeInterval = 60 * 60 * 24
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayChallenge()
    }
    
    /// Checks if the creation time has lapsed 24 hours.
    private var hasTwentyFourHoursPassed: Bool {
        guard let challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date else { return false }
        return abs(challengeCreationTime.timeIntervalSinceNow) > secondsInTwentyFourHours
    }
    
    /// Handles if it needs to display a new random challenge or fetch previously displayed challenge.
    func displayChallenge() {
        if hasTwentyFourHoursPassed {
            displayNewChallenge()
            skipCount = 0
            completedButton.isHidden = true
            skipButton.isHidden = true
        } else {
            guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64 else { return }
            challenge = Challenge.fetch(with: id, in: context)
        }
    }
    
    private func displayNewChallenge() {
        guard let context = managedObjectContext, let challenge = Challenge.fetchRandomChallenge(from: context) else { return }
        UserDefaults.standard.set(Date(), forKey: creationTimeKey)
        self.challenge = challenge
    }
    
    // Configure ChallengeVC UI using Challenge object
    
    func setupChallengeUI(with challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        if let category = challenge.category {
            categoryImageView.image = UIImage(named: category)
        }
    }
    
    func changeCompletionStatus() {
        guard let context = managedObjectContext, let id = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64, let challenge = Challenge.fetch(with: id, in: context) else { return  }
        print(challenge)
        challenge.isCompleted = true
        print(challenge)
    }
    
    func showSkipAlert() {
        let alert = UIAlertController(title: "Out of Skips", message: "You're out of skips for the next 24 hours. Try to complete the challenge!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - Actions
    
    // on press dismiss current challenge object and update UI to display new challenge object.
    // if skip is clicked 3 times any addition clicks will trigger HUD informing there are no more skips allowed for 24 hours.
    // after 24 hours reset number of allowed skips to 3
    @IBAction func skipButton(_ sender: Any ) {
//        UserDefaults.standard.set(skipCount, forKey: skipCountKey)
        skipCount += 1
        if skipCount > 3 {
            showSkipAlert()
        } else {
            displayNewChallenge()
        }
    }
    
    @IBAction func completeButton(for segue: UIStoryboardSegue, sender: Any?) {

        // on press trigger HUD celebrating Challenge completion.
//        showChallengeCompletedAlert()
        
        // change Challenge.isCompleted to true until all challenges are complete or 1 year passes.
//        hasChallengeCompleted()
        
        // display pending challenge view for 24 hours informing user must wait 24 hours for a new challenge and that they will be notified
        // after 24 hours use local notification to alert user new challenge is available.
        // Use count of completed challenges to reward user with a fortune every 7 completed challenges
        // update StatsViewController to display percentage and ratio of completed challenges, filtered by category
    }
    
    func updateUI() {
        skipButton.isOpaque = true
        skipButton.isEnabled = false
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateUI()
        changeCompletionStatus()
        
        if segue.identifier == "showPendingViewController" {
            guard let controller = segue.destination as? PendingChallengeViewController else { return }
            controller.secondsInTwentyFourHours = secondsInTwentyFourHours
            controller.challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date
        }
    }
}

