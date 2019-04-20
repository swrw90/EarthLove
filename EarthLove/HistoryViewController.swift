//
//  SecondViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

// MARK - Protocols
protocol  HistoryViewControllerDelegate: AnyObject {
    
    // Set hasCompletedAChallenge to true.
    func hasCompletedAChallenge()
}

private let historyCell = "HistoryCell"
private let nothingFoundCell = "NothingFoundCell"
private let showChallengeViewControllerKey = "showChallengeViewController"
private let categoriesMenuIdentifier = "CategoriesMenu"
private let challengeViewControllerIdentifier = "ChallengeViewController"


/// MARK: - Displays the history of users completed challenges.
class HistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    var selectedCategory: Category?
    var completedChallenge: Challenge?
    private var categoriesMenuViewController: CategoriesMenuViewController?
    private var blurEffectView: UIView?
    
    let hasCompletedAChallengeKey = "hasCompletedAChallenge"
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryHeader: UIButton!
    
    
    // MARK: - NSFetchedResultsController
    
    // Set delegate for any old versions of fetchedResultsController to nil to prevent memory leaks.
    private var _fetchedResultsController: NSFetchedResultsController<Challenge>? {
        didSet {
            oldValue?.delegate = nil
        }
    }
    
    /// Check if fetchedResultsController already exists, if so return it, if not create a new instance of fetchedResultsController and set it to _fetchedResultsController.
    private var fetchedResultsController: NSFetchedResultsController<Challenge> {
        guard let context = managedObjectContext else { fatalError("Couldn't find context.") }
        
        // Check if fetchedResultsController already exists.
        if let fetchedResultsController = _fetchedResultsController { return fetchedResultsController }
        
        var fetchedResultsController: NSFetchedResultsController<Challenge>
        let fetchRequest = Challenge.completedChallengesFetchRequest(category: selectedCategory)
        
        // Create an instance of NSFetchedResultsController using fetchRequest and context.
        fetchedResultsController = NSFetchedResultsController<Challenge>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        // Set value of _fetchedResultsController.
        _fetchedResultsController = fetchedResultsController
        
        do {
            // performFetch can throw, try performFetch and catch any errors.
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch data \(error)")
        }
        
        return fetchedResultsController
    }
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        displayZeroStateView()
    }
    
    /// Display zeroStateView if no challenges completed, else display history table view.
    private func displayZeroStateView() {
        guard let hasCompletedAChallenge = UserDefaults.standard.value(forKey: hasCompletedAChallengeKey) as? Bool else { return }
        
        guard let zeroStateView = ZeroStateView.instanceOfZeroStateViewNib() as? ZeroStateView else { return }
        
        if hasCompletedAChallenge == false {
            self.view.addSubview(zeroStateView)
            
        } else if hasCompletedAChallenge == true {
            
            for view in self.view.subviews where view is ZeroStateView {
                view.removeFromSuperview()
            }
            
            tableView.rowHeight = 80
            
            var cellNib = UINib(nibName: historyCell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: historyCell)
            
            cellNib = UINib(nibName: nothingFoundCell, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: nothingFoundCell)
        }
    }
    
    /// Get an array of all complted challenges.
    private func getCompletedChallenges() -> [Challenge] {
        guard let context = managedObjectContext else { return [] }
        return Challenge.fetchCompletedChallenges(from: context)
    }
    
    // Creates and animates an instance of CategoriesMenuViewController.
    @IBAction func displayCategoriesMenu(_ sender: Any) {
        
        guard categoriesMenuViewController == nil else {
            UIView.animate(withDuration: 0.3, animations: {
                self.categoriesMenuViewController?.view.frame.origin.y = self.view.frame.maxY
                self.blurEffectView?.alpha = 0.0
            }, completion: { _ in
                // Remove categoriesMenuVC from view stack.
                self.categoriesMenuViewController?.willMove(toParent: nil)
                
                self.categoriesMenuViewController = nil
                
                self.blurEffectView?.removeFromSuperview()
            })
            
            
            return
        }
        
        guard let categoriesMenuVC: CategoriesMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: categoriesMenuIdentifier) as? CategoriesMenuViewController else { return }
        
        self.categoriesMenuViewController = categoriesMenuVC
        
        categoriesMenuVC.delegate = self
        let newFrame = CGRect(x: view.frame.origin.x, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
        
        categoriesMenuVC.view.frame = newFrame
        categoriesMenuVC.willMove(toParent: self)
        
        addChild(categoriesMenuVC)
        view.addSubview(categoriesMenuVC.view)
        
        categoriesMenuVC.didMove(toParent: self)
        
        // Create an instance of UIVisualEffectView with blur effect, animate and add to view stack to blur view behind categoriesMenuVC.
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 1)
        blurEffectView.alpha = 0.0
        
        self.blurEffectView = blurEffectView
        
        UIView.animate(withDuration: 0.3) {
            blurEffectView.alpha = 1.0
            categoriesMenuVC.view.frame.origin.y = self.view.frame.height / 2
        }
    }
}


//MARK: - TableView Data Source

/// Handle HistoryViewController TableView setup.
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns a row for each fetched object or 1 row for NothingFoundCell if fetched objects is nil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }
    
    // Returns a UITableViewCell with UILabel and UIImage values set.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell to be reused.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: historyCell, for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        // Assign at the indexPath to challenge constant to be displayed in the returned cell.
        let challenge = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = challenge.title
        cell.subTitleLabel.text = challenge.category.rawValue
        cell.categoryImageView.image = challenge.category.iconImage
        
        return cell
    }
    
    // Creates an instance of ChallangeVC when row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set completedChallenge to the challenge selected from the tableview.
        completedChallenge = fetchedResultsController.object(at: indexPath)
        
        let challengeVC = storyboard!.instantiateViewController(withIdentifier: "ChallengeViewController") as! ChallengeViewController
        
        challengeVC.completedChallenge = completedChallenge
        challengeVC.navigationItem.rightBarButtonItem = nil
        show(challengeVC, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Prepares to segue to ChallengeViewController after completed challenge is selected.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showChallengeViewControllerKey {
            guard let navController = segue.destination as? UINavigationController, let challengeVC = navController.viewControllers.first as? ChallengeViewController else { return }
            challengeVC.completedChallenge = completedChallenge
            
        }
    }
    
}


// MARK: - FecthedResultsControllerDelegate.

/// Reloads tableView if HistoryVC content has changed.
extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


// MARK: - CategoriesMenuViewControllerDelegate.

// Executes protocol methods for CategoriesMenuViewControllerDelegate.
extension HistoryViewController: CategoriesMenuViewControllerDelegate {
    
    // Animates categoriesMenuVC and blurEffectView after category is selected and removes both views from stack upon completion.
    func handleSelectedCategory(category: Category) {
        UIView.animate(withDuration: 0.3, animations: {
            self.categoriesMenuViewController?.view.frame.origin.y = self.view.frame.maxY
            self.blurEffectView?.alpha = 0.0
        }, completion: { _ in
            // Remove categoriesMenuVC from view stack.
            self.categoriesMenuViewController?.willMove(toParent: nil)
            
            self.categoriesMenuViewController = nil
            
            self.blurEffectView?.removeFromSuperview()
        })
        
        if category == .all {
            selectedCategory = nil
            categoryHeader.setTitle("all", for: .normal)
        } else {
            selectedCategory = category
            categoryHeader.setTitle(selectedCategory?.rawValue, for: .normal)
        }
        
        _fetchedResultsController = nil
        
        self.tableView.reloadData()
    }
}
