//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Outlets
    
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeDescription: UITextView!
    
    
    //MARK: - Actions
    
    @IBAction func skipButton(_ sender: Any) {
    }
    
    @IBAction func completeButton(_ sender: Any) {
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
