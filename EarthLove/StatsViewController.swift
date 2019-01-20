//
//  StatsScreenViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/20/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController {
    
    
    // MARK: - Properties
    var managedObjectContext: NSManagedObjectContext?
    
    
    private var allCompletedCount: Int? {
        didSet {
            print("Old value\(String(describing: oldValue)) new value \(String(describing: allCompletedCount))")
            guard oldValue != allCompletedCount else { return }
            
            if let allCompletedCount = allCompletedCount {
                print("oldValue is \(allCompletedCount)")
            }
        }
    }
    
    
    //    MARK: - Outlets
    
    // Labels to display percentages for each category.
    @IBOutlet weak var homePercentageLabel: UILabel!
    @IBOutlet weak var workPercentageLabel: UILabel!
    @IBOutlet weak var recreationalPercentageLabel: UILabel!
    @IBOutlet weak var volunteerPercentageLabel: UILabel!
    
    // Labels to display ratio of completed challenges to uncompleted for each category.
    @IBOutlet weak var homeRatioLabel: UILabel!
    @IBOutlet weak var workRatioLabel: UILabel!
    @IBOutlet weak var recreationalRatioLabel: UILabel!
    @IBOutlet weak var volunteerRatioLabel: UILabel!
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        
    }
    
    
    /// Returns percentage of completed challenges for home category.
    private func calculateCompletedPercentage(with category: Category) -> Int? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        guard let completedChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: category) else { return nil }
        
        let challengesCompletedPercentage = Double(completedChallengesCount) / Double(contextCount) * 100.0
        
        return Int(challengesCompletedPercentage)
    }

    
    /// Update Stats view labels and UI with challenge completion percentage and ratio of complete to incomplete.
    private func setupUI() {
        
        guard let context = managedObjectContext else { return }
        
        // Set completed challenge value to UILabel text.
        guard let homeChallengePercentage = calculateCompletedPercentage(with: .home) else { return }
        
        homePercentageLabel.text = String(homeChallengePercentage) + "%"
        
        guard let workChallengePercentage = calculateCompletedPercentage(with: .work) else { return }
        
        workPercentageLabel.text = String(workChallengePercentage) + "%"
        
        guard let recreationalChallengePercentage = calculateCompletedPercentage(with: .recreational) else { return }
        
        recreationalPercentageLabel.text = String(recreationalChallengePercentage) + "%"
        
        guard let volunteerChallengePercentage = calculateCompletedPercentage(with: .volunteer) else { return }
        
        volunteerPercentageLabel.text = String(volunteerChallengePercentage) + "%"
        
        // Set count of challenges completed & incomplete ratio to UILabel.
        // Home UILabel
        guard let completedHomeChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: .home) else { return }
        
        guard let allHomeChallengesCount = Challenge.getAllChallengesCount(in: context, with: .home) else { return }
        
        homeRatioLabel.text = "\(completedHomeChallengesCount) / \(allHomeChallengesCount)"
        
        // Work UILabel
        guard let completedWorkChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: .work) else { return }
        
        guard let allWorkChallengesCount = Challenge.getAllChallengesCount(in: context, with: .work) else { return }
        
        workRatioLabel.text = "\(completedWorkChallengesCount) /\(allWorkChallengesCount)"
        
        // Recreational UILabel
        guard let completedRecreationalChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: .recreational) else { return }
        
        guard let allRecreationalChallengesCount = Challenge.getAllChallengesCount(in: context, with: .recreational) else { return }
        
        recreationalRatioLabel.text = "\(completedRecreationalChallengesCount) /\(allRecreationalChallengesCount)"
        
        // Volunteer UILabel
        guard let completedVolunteerChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: .volunteer) else { return }
        
        guard let allVolunteerChallengesCount = Challenge.getAllChallengesCount(in: context, with: .volunteer) else { return }
        
        volunteerRatioLabel.text = "\(completedVolunteerChallengesCount) /\(allVolunteerChallengesCount)"
    }
}
