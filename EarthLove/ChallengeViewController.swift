//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

class ChallengeViewController: UIViewController {
    
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
        
        displayNewChallenge()
    }
    
    
    private func displayNewChallenge() {
        if let context = managedObjectContext {
            
            if let fetchRequest = Challenge.createRandomChallengeFetchRequest(with: context) {
                
                if let challenge = Challenge.fetchRandomChallenge(with: fetchRequest, in: context) {
                    setupChallengeUI(with: challenge)
                }
            }
        }
    }
    
    
    
    func setupChallengeUI(with challenge: Challenge) {
        titleLabel.text = challenge.title
        descriptionLabel.text = challenge.summary
        if let category = challenge.category {
            categoryImageView.image = UIImage(named: category)
        }
    }
    
    
    //MARK: - Actions
    
    // if clicked dismiss current challenge object and update UI to display new challenge object.
    // if skip is clicked 3 times any addition clicks will trigger HUD informing there are no more skips allowed for 24 hours.
    // after 24 hours reset number of allowed skips to 3
    @IBAction func skipButton(_ sender: Any ) {
        displayNewChallenge()
        skipCount += 1
        
        if skipCount == 3 {
            print("3 skips")
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

