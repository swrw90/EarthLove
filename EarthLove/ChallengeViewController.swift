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
    
    private var challenge: ChallengeTestModel?

    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challenge = ChallengeTestModel(title: "Test title for challenge", image: UIImage(named: "gamer"), description: "This is a test description that needs to be displayed on to the screen.")
    
        setupUI()
    }
    
    func setupUI() {
        titleLabel.text = challenge?.title
        descriptionLabel.text = challenge?.description
        categoryImageView.image = challenge?.image
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
