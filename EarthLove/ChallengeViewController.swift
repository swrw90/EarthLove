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
    var skipCount = 0
    let challengeIdentifierKey = "identifier"
    let creationTimeKey = "creationTime"
    let secondsInTwentyFourHours: TimeInterval = 60 * 60 * 24
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for a challengeIdentifier, if there isn't one call displayNewChallenge
        if let challengeIdentifier = UserDefaults.standard.value(forKey: challengeIdentifierKey) as? Int64 {
            // Unwrap the UserDefault stored value for the challenge's creationTime
            if let challengeCreationTime = UserDefaults.standard.value(forKey: creationTimeKey) as? Date {
                // Use the challenge creation time value to check if 24 hours has passed since the challenge was created
                if abs(challengeCreationTime.timeIntervalSinceNow) > secondsInTwentyFourHours {
                    displayNewChallenge()
                } else {
                    // Time lapsed since last challenge is less than 24 hours, fetch the most recently displayed challenge by its identifier and set it to challenge property.
                    if let context = managedObjectContext {
                       self.challenge = Challenge.fetch(with: challengeIdentifier, in: context)
                    }
                }
            } else {
                displayNewChallenge()
            }
        } else {
            displayNewChallenge()
        }
    }
    
    private func displayNewChallenge() {
        
        if let context = managedObjectContext {
            
            if let fetchRequest = Challenge.createRandomChallengeFetchRequest(with: context) {
                if let challenge = Challenge.fetchRandomChallenge(with: fetchRequest, in: context) {
                    // Create a shared defaults object and set it's forKey value to Date()
                    UserDefaults.standard.set(Date(), forKey: creationTimeKey)
                    self.challenge = challenge
                }
            }
        }
    }
    
    
    // Configure ChallengeVC UI using Challenge object
    
    func setupChallengeUI(with challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        if let category = challenge.category {
            categoryImageView.image = UIImage(named: category)
        }
    }
    
    func showSkipAlert() {
        let alert = UIAlertController(title: "Out of Skips", message: "You're out of skips for the next 24 hours. Try to complete the challenge!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    // if clicked dismiss current challenge object and update UI to display new challenge object.
    // if skip is clicked 3 times any addition clicks will trigger HUD informing there are no more skips allowed for 24 hours.
    // after 24 hours reset number of allowed skips to 3
    @IBAction func skipButton(_ sender: Any ) {
        skipCount += 1
        
        if skipCount >= 3 {
            showSkipAlert()
        } else {
            displayNewChallenge()
        }
        
        
    }
    
    @IBAction func completeButton(_ sender: Any) {
        
        print("called")
        // if clicked trigger HUD celebrating Challenge completion.
        // change Challenge.isCompleted to true until all challenges are complete or 1 year passes.
        // display pending challenge view for 24 hours informing user must wait 24 hours for a new challenge and that they will be notified
        // after 24 hours use local notification to alert user new challenge is available.
        // Use count of completed challenges to reward user with a fortune every 7 completed challenges
        // update StatsViewController to display percentage and ratio of completed challenges, filtered by category
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

