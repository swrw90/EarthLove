//
//  StatsScreenViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/20/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

/// Display percentage of challenges completed and ratio of completed to incomplete.
class StatsViewController: UIViewController {
    
    
    // MARK: - Properties
    var managedObjectContext: NSManagedObjectContext?
    
    private var allChallengesCount: Int? {
        guard let context = managedObjectContext else { return nil }
        
        return Challenge.getAllChallengesCount(in: context)
    }
    
    private var allCompletedCount: Int? {
        didSet {
            guard oldValue != allCompletedCount else { return }
            setupUI()
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
        
        guard let context = managedObjectContext else { return }
        allCompletedCount = Challenge.getAllCompletedChallengesCount(in: context)
        
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
        
        Category.allCases.forEach {
            configureUI(for: $0, with: context)
        }
        
    }
    
    /// Set values from challenges count and percentages to UILabels.
    private func configureUI(for category: Category, with context: NSManagedObjectContext) {
         guard let categoryChallengePercentage = calculateCompletedPercentage(with: category), let categoryChallengesCount = Challenge.getAllCompletedChallengesCount(in: context, with: category), let allCategoryChallengesCount = Challenge.getAllChallengesCount(in: context, with: category) else { return }
        
        switch category {
        case .home:
            homePercentageLabel.text = String(categoryChallengePercentage) + "%"
            homeRatioLabel.text = "\(categoryChallengesCount) / \(allCategoryChallengesCount)"
        case .work:
            workPercentageLabel.text = String(categoryChallengePercentage) + "%"
            workRatioLabel.text = "\(categoryChallengesCount) / \(allCategoryChallengesCount)"
        case .recreational:
            recreationalPercentageLabel.text = String(categoryChallengePercentage) + "%"
            recreationalRatioLabel.text = "\(categoryChallengesCount) / \(allCategoryChallengesCount)"
        case .volunteer:
            volunteerPercentageLabel.text = String(categoryChallengePercentage) + "%"
            volunteerRatioLabel.text = "\(categoryChallengesCount) / \(allCategoryChallengesCount)"
        }
    }
}
