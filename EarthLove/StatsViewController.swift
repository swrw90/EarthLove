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
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calculateStatsPercetanges()
        
    }
    private func getCompletedChallengesByCategory() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedChallengesByCategory = Challenge.createCompletedByCategoryFetchRequest(category: .work, from: context)
        
        return completedChallengesByCategory
    }
    
    private func calculateStatsPercetanges() {
        guard let context = managedObjectContext else { return }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return }
        
        let completedWorkChallenges = getCompletedChallengesByCategory()
        let completedWorkChallengesCount = completedWorkChallenges.count
        
        print(contextCount, "Context Count")
        print(completedWorkChallengesCount, "Work Count")
        
//        let workChallengePercentage = completedWorkChallengesCount / contextCount * 100

        let workChallengePercentage = 12 / 33 * 100
        
        print(workChallengePercentage, "Work Challenges Percentage")
    }
}
