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
    
    /// Returns an array of Challenge objects for a specific category.
    private func getCompletedChallengesByCategory() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedChallengesByCategory = Challenge.createCompletedByCategoryFetchRequest(category: .work, from: context)
        
        return completedChallengesByCategory
    }
    
    /// Returns percentages of completed challenges for each category.
    private func calculateStatsPercetanges() -> Int? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil}
        
        let completedWorkChallenges = getCompletedChallengesByCategory()
        let completedWorkChallengesCount = completedWorkChallenges.count
        
        print(contextCount, "Context Count")
        print(completedWorkChallengesCount, "Work Count")

//        let workChallengePercentage = Int(completedWorkChallengesCount / contextCount * 100)
        let workChallengePercentage = 1 / 13
        print(workChallengePercentage, "Work Challenges Percentage")
        
        return 0 // workChallengePercentage
    }
}
