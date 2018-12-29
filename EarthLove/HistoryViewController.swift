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

class HistoryViewController: UIViewController {
    
    
    // MARK: - Properties

    var managedObjectContext: NSManagedObjectContext?
//    var challenges = [Challenge]() {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    //MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - NSFetchedResultsController
    
    private var _fetchedResultsController: NSFetchedResultsController<Challenge>? {
        didSet {
            oldValue?.delegate = nil
        }
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Challenge> {
        guard let context = managedObjectContext else { fatalError("Couldn't find context.") }
        if let fetchedResultsController = _fetchedResultsController { return fetchedResultsController }
        
        var fetchedResultsController: NSFetchedResultsController<Challenge>
        
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.predicate = Challenge.isCompletedPredicate
        fetchRequest.sortDescriptors = [] // Support ordering by completion date
        
        fetchedResultsController = NSFetchedResultsController<Challenge>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        _fetchedResultsController = fetchedResultsController
        
        do {
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

        
//        challenges = getCompletedChallenges()
    }
    
    private func getCompletedChallenges() -> [Challenge] {
        guard let context = managedObjectContext else { return [] }
        return Challenge.fetchCompletedChallenges(from: context)
    }
}

//MARK: - TableView Data Source

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if challenges.count == 0 {
//            return 1
//        } else {
//            return challenges.count
//        }
        
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if challenges.count == 0 {
//            return tableView.dequeueReusableCell(withIdentifier: nothingFoundCell, for: indexPath)
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as! SearchResultCell
//
//            let challenge = challenges[indexPath.row]
//            cell.titleLabel.text = challenge.title
//            cell.subTitleLabel.text = challenge.category
//            return cell
//        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCell, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
        
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
