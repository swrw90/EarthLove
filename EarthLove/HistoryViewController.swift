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

/// MARK: - Displays the history of users completed challenges.
class HistoryViewController: UIViewController {
    
    
    // MARK: - Properties

    var managedObjectContext: NSManagedObjectContext?
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        
        // TODO: - Move to core data class as a func
        // Create a fetchRequest for completed challenges.
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.predicate = Challenge.isCompletedPredicate
        fetchRequest.sortDescriptors = [] // Support ordering by completion date
        
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
    
    private func getCompletedChallenges() -> [Challenge] {
        guard let context = managedObjectContext else { return [] }
        return Challenge.fetchCompletedChallenges(from: context)
    }
}

//MARK: - TableView Data Source

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        
        // Assign at the indexPath to challenge constant to be displayed in the returned cell.
        let challenge = fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = challenge.title
        cell.subTitleLabel.text = challenge.category
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - SearchBarDelegate

extension HistoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
