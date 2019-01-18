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
    
    private var allCompletedCount: Int? = 1 {
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
        guard let context = managedObjectContext else { return }
        
        guard let allChallengeByCategoryCount = Challenge.getAllChallengesCount(in: context, with: .work) else { return }
        allCompletedCount = Int(allChallengeByCategoryCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
        
    }
    
    
    /// Returns an array of Challenge objects for a honme category.
    private func getCompletedChallenges(with category: Category) -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        return Challenge.createCompletedByCategoryFetchRequest(category: category, from: context)
    }
    
    /// Returns percentage of completed challenges for home category.
    private func calculateHomePercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedHomeChallenges = getCompletedChallenges(with: .home)
        let completedHomeChallengesCount = Double(completedHomeChallenges.count)
        
        let homeChallengePercentage = Double(completedHomeChallengesCount / contextCount * 100.0)
        
        return homeChallengePercentage
    }
    
    /// Returns percentage of completed challenges for work category.
    private func calculateWorkPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedWorkChallenges = getCompletedChallenges(with: .work)
        let completedWorkChallengesCount = Double(completedWorkChallenges.count)
        
        let workChallengePercentage = Double(completedWorkChallengesCount / contextCount * 100.0)
        
        return workChallengePercentage
    }
    
    /// Returns percentage of completed challenges for recreational category.
    private func calculateRecreationalPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedRecreationalChallenges = getCompletedChallenges(with: .recreational)
        let completedRecreationalChallengesCount = Double(completedRecreationalChallenges.count)
        
        let recreationalChallengePercentage = Double(completedRecreationalChallengesCount / contextCount * 100.0)
        
        return recreationalChallengePercentage
    }
    
    /// Returns percentage of completed challenges for volunteer category.
    private func calculateVolunteerPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedVolunteerChallenges = getCompletedChallenges(with: .volunteer)
        let completedVolunteerChallengesCount = Double(completedVolunteerChallenges.count)
        
        let volunteerChallengePercentage = Double(completedVolunteerChallengesCount / contextCount * 100.0)
        
        return volunteerChallengePercentage
    }
    
    /// Update Stats view labels and UI.
    private func setupUI() {
        
        guard let context = managedObjectContext else { return }
        
        guard let homeChallengePercentage = calculateHomePercentage() else { return }
        guard let workChallengePercentage = calculateWorkPercentage() else { return }
        guard let recreationalChallengePercentage = calculateRecreationalPercentage() else { return }
        guard let volunteerChallengePercentage = calculateVolunteerPercentage() else { return }
        
        homePercentageLabel.text = String(Int(homeChallengePercentage)) + "%"
        workPercentageLabel.text = String(Int(workChallengePercentage)) + "%"
        recreationalPercentageLabel.text = String(Int(recreationalChallengePercentage)) + "%"
        volunteerPercentageLabel.text = String(Int(volunteerChallengePercentage)) + "%"
        
        // Home challenges ratio count label.
        guard let allHomeChallengesCount = Challenge.getAllChallengesCount(in: context, with: .home) else { return }
        
        let completedHomeChallenges = getCompletedChallenges(with: .home)
        
        homeRatioLabel.text = "\(completedHomeChallenges.count) / \(Int(allHomeChallengesCount))"
        
        // Work challenges ratio count label.
        let completedWorkChallenges = getCompletedChallenges(with: .work)
        
        guard let allWorkChallengesCount = Challenge.getAllChallengesCount(in: context, with: .work) else { return }
        
        workRatioLabel.text = "\(completedWorkChallenges.count) /\(Int(allWorkChallengesCount))"
        
        // Recreational challenges ratio count label.
        let completedRecreationalChallenges = getCompletedChallenges(with: .recreational)
        
        guard let allRecreationalChallengesCount = Challenge.getAllChallengesCount(in: context, with: .recreational) else { return }
        
        recreationalRatioLabel.text = "\(completedRecreationalChallenges.count) / \(Int(allRecreationalChallengesCount))"
        
        // Volunteer challenges ratio count label.
        let completedVolunteerChallenges = getCompletedChallenges(with: .volunteer)
        
        guard let allVolunteerChallengesCount = Challenge.getAllChallengesCount(in: context, with: .volunteer) else { return }
        
        volunteerRatioLabel.text = "\(completedVolunteerChallenges.count) / \(Int(allVolunteerChallengesCount))"
        
    }
}
