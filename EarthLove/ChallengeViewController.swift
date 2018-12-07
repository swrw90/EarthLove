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
    
    // MARK: - Outlets
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    // MARK: - Properties
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = managedObjectContext {
            
            if let fetchRequest = Challenge.createRandomChallengeFetchRequest(with: context) {
                
                if let challenge = Challenge.fetchRandomChallenge(with: fetchRequest, in: context) {
//                    print(challenge)
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
    
    @IBAction func skipButton(_ sender: Any) {
    }
    
    @IBAction func completeButton(_ sender: Any) {
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

