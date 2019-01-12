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
        setupUI()
        
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
    private func getCompletedHomeChallenges() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedHomeChallenges = Challenge.createCompletedByCategoryFetchRequest(category: .home, from: context)
        
        return completedHomeChallenges
    }
    
    /// Returns an array of Challenge objects for a specific category.
    private func getCompletedWorkChallenges() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedWorkChallenges = Challenge.createCompletedByCategoryFetchRequest(category: .work, from: context)
        
        return completedWorkChallenges
    }
    
    /// Returns an array of Challenge objects for a specific category.
    private func getCompletedRecreationalChallenges() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedRecreationalChallenges = Challenge.createCompletedByCategoryFetchRequest(category: .recreational, from: context)
        
        return completedRecreationalChallenges
    }
    
    /// Returns an array of Challenge objects for a specific category.
    private func getCompletedVolunteerChallenges() -> [Challenge]{
        guard let context = managedObjectContext else { return [] }
        
        let completedVolunteerChallenges = Challenge.createCompletedByCategoryFetchRequest(category: .volunteer, from: context)
        
        return completedVolunteerChallenges
    }
    
    /// Returns percentage of completed challenges for home category.
    private func calculateHomePercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedHomeChallenges = getCompletedHomeChallenges()
        let completedHomeChallengesCount = Double(completedHomeChallenges.count)
        
        let homeChallengePercentage = Double(completedHomeChallengesCount / contextCount * 100.0)
        
        return homeChallengePercentage
    }
    
    /// Returns percentage of completed challenges for work category.
    private func calculateWorkPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedWorkChallenges = getCompletedWorkChallenges()
        let completedWorkChallengesCount = Double(completedWorkChallenges.count)
        
        let workChallengePercentage = Double(completedWorkChallengesCount / contextCount * 100.0)
        
        return workChallengePercentage
    }
    
    /// Returns percentage of completed challenges for recreational category.
    private func calculateRecreationalPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedRecreationalChallenges = getCompletedRecreationalChallenges()
        let completedRecreationalChallengesCount = Double(completedRecreationalChallenges.count)
        
        let recreationalChallengePercentage = Double(completedRecreationalChallengesCount / contextCount * 100.0)
        
        return recreationalChallengePercentage
    }
    
    /// Returns percentage of completed challenges for volunteer category.
    private func calculateVolunteerPercentage() -> Double? {
        guard let context = managedObjectContext else { return nil }
        guard let contextCount = Challenge.getAllChallengesCount(in: context) else { return nil }
        
        let completedVolunteerChallenges = getCompletedVolunteerChallenges()
        let completedVolunteerChallengesCount = Double(completedVolunteerChallenges.count)
        
        let volunteerChallengePercentage = Double(completedVolunteerChallengesCount / contextCount * 100.0)
        
        return volunteerChallengePercentage
    }
    
    private func setupUI() {
        guard let homeChallengePercentage = calculateHomePercentage() else { return }
        guard let workChallengePercentage = calculateWorkPercentage() else { return }
        guard let recreationalChallengePercentage = calculateRecreationalPercentage() else { return }
        guard let volunteerChallengePercentage = calculateVolunteerPercentage() else { return }
        
        homePercentageLabel.text = String(Int(homeChallengePercentage)) + "%"
        workPercentageLabel.text = String(Int(workChallengePercentage)) + "%"
        recreationalPercentageLabel.text = String(Int(recreationalChallengePercentage)) + "%"
        volunteerPercentageLabel.text = String(Int(volunteerChallengePercentage)) + "%"
        
        let completedHomeChallenges = getCompletedHomeChallenges()
        let completedHomeChallengesCount = String(Int(completedHomeChallenges.count))
        
        let completedWorkChallenges = getCompletedWorkChallenges()
        let completedWorkChallengesCount = String(Int(completedWorkChallenges.count))
        
        let completedRecreationalChallenges = getCompletedRecreationalChallenges()
        let completedRecreationalChallengesCount = String(Int(completedRecreationalChallenges.count))
        
        let completedVolunteerChallenges = getCompletedVolunteerChallenges()
        let completedVolunteerChallengesCount = String(Int(completedVolunteerChallenges.count))
        
        homeRatioLabel.text = completedHomeChallengesCount + "/200"
        workRatioLabel.text = completedWorkChallengesCount + "/200"
        recreationalRatioLabel.text = completedRecreationalChallengesCount + "/200"
        volunteerRatioLabel.text = completedVolunteerChallengesCount + "/200"
    }
}
