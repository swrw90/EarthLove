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
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calculateStatsPercetanges()
        
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
    
    
    
    
    /// Returns an array of Challenge objects for a specific category.
    private func getCompletedChallengesByCategory() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedChallengesByCategory = Challenge.createCompletedByCategoryFetchRequest(category: .work, from: context)
        
        return completedChallengesByCategory
    }
    
    /// Returns percentages of completed challenges for each category.
    private func calculateStatsPercetanges() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil}
        
        let completedWorkChallenges = getCompletedChallengesByCategory()
        let completedWorkChallengesCount = Double(completedWorkChallenges.count)
        
        print(contextCount, "Context Count")
        print(completedWorkChallengesCount, "Work Count")

        let workChallengePercentage = Double(completedWorkChallengesCount / contextCount * 100.0)

        print(workChallengePercentage, "Work Challenges Percentage")
        
        return workChallengePercentage
    }
}
