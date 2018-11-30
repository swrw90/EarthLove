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
        
        setupUI()
    }
    
    func setupUI() {
//        titleLabel.text = challenge?.title
//        descriptionLabel.text = challenge?.description
//        categoryImageView.image = challenge?.image
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
