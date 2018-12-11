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
    let currentDateTime = Date()
    var dateComponents = DateComponents()
    let formatter = DateFormatter()
    let hour = Calendar.current.component(.hour, from: Date())
    var managedObjectContext: NSManagedObjectContext?
    var skipCount = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    // MARK: - Properties
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateComponents.timeZone = TimeZone(abbreviation: "PDT")
        print(currentDateTime)
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        print("hour: \(hour)")
        displayNewChallenge()
    }
    
    
    private func displayNewChallenge() {
        
        if let context = managedObjectContext {
            
            if let fetchRequest = Challenge.createRandomChallengeFetchRequest(with: context) {
                // Create a shared defaults object and set it's forKey value to Date()
                UserDefaults.standard.set(Date(), forKey:"creationTime")
                
                // Unwrap the defaults object forKey "creationTime"
                if let date = UserDefaults.standard.object(forKey: "creationTime") as? Date {
                    
                    // Compare the defaults object to to current Date by our, if >= 24 set skipCount to 0 and allow skipping Challenges
                    if let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour, diff >= 24 {
                        skipCount = 0
                    }
                }
               
                if let challenge = Challenge.fetchRandomChallenge(with: fetchRequest, in: context) {
                    
                    setupChallengeUI(with: challenge)
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

