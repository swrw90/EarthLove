//
//  FirstViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Outlets
    
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UITextView!
    
    
    //MARK: - Actions
    
    @IBAction func skipButton(_ sender: Any) {
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
    }
    
    
    @IBAction func completeButton(_ sender: Any) {
    }
    
    
    @IBAction func statsButton(_ sender: Any) {
    }
    
    @IBAction func taskDetailButton(_ sender: Any) {
    }
}

