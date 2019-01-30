//
//  SecondViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData

private let searchResultCell = "SearchResultCell"
private let nothingFoundCell = "NothingFoundCell"
private let showChallengeViewControllerKey = "showChallengeViewController"
private let categoriesMenuIdentifier = "CategoriesMenu"


/// MARK: - Displays the history of users completed challenges.
class HistoryViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    
    
    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
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
        let fetchRequest = Challenge.completedChallengesFetchRequest()
        
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
        tableView.rowHeight = 80
        
        var cellNib = UINib(nibName: searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: searchResultCell)
        
        cellNib = UINib(nibName: nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: nothingFoundCell)
        
    }
    
    /// Get an array of all complted challenges.
    private func getCompletedChallenges() -> [Challenge] {
        guard let context = managedObjectContext else { return [] }
        return Challenge.fetchCompletedChallenges(from: context)
    }
    
    @IBAction func displayCategoriesMenu(_ sender: Any) {
        
        // Creates an instance of CategoriesMenuViewController
        guard let categoriesMenuVC: CategoriesMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: categoriesMenuIdentifier) as? CategoriesMenuViewController else { return }
        
        // Defines the constraints of the overlay view, using IB auto-constraints.
        categoriesMenuVC.view.frame = self.view.bounds;
        
        // Called by addChild just before adding categoriesVC over top historyVC to prepare.
        categoriesMenuVC.willMove(toParent: self)
        
        // Adds categoriesMenuVC to top level of view hierchy list.
        self.view.addSubview(categoriesMenuVC.view)
        
        // Adds categoriesMenuVC as a child to historyVC
        self.addChild(categoriesMenuVC)
        
        // Called after categoriesVc has moved as an overlay to historyVC.
        categoriesMenuVC.didMove(toParent: self)
        
    }
}



//MARK: - TableView Data Source

/// Handle TableView setup.
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns a row for each fetched object or 1 row for NothingFoundCell if fetched objects is nil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }
    
    // Returns a UITableViewCell with UILabel and UIImage values set.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cell to be reused.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        
        // Assign at the indexPath to challenge constant to be displayed in the returned cell.
        let challenge = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = challenge.title
        cell.subTitleLabel.text = challenge.category.rawValue
        cell.categoryImageView.image = challenge.category.iconImage
        
        return cell
    }
    
    // Animates cell when it is pressed.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, segue: UIStoryboardSegue, sender: Any?) {
        print("called")
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: showChallengeViewControllerKey, sender: nil)
        
        if segue.identifier == showChallengeViewControllerKey {
            guard let controller = segue.destination as? ChallengeViewController
                else { return }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showChallengeViewControllerKey {
                    print("called here")
            guard let controller = segue.destination as? ChallengeViewController
                else { return }
        }
    }
    
    
}


//MARK: - SearchBarDelegate


/// Reloads tableView if HistoryVC content has changed. 
extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

//
