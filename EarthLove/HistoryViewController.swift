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
private let challengeViewControllerIdentifier = "ChallengeViewController"


/// MARK: - Displays the history of users completed challenges.
class HistoryViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var managedObjectContext: NSManagedObjectContext?
    
    // 5. create a selectedCategory property.
    var selectedCategory: Category?
    
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
        
        // 8. set fetchRequest predicate to filter out everything but selected category. Only do this IF selectedCategory exists.
        
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
        
        // 2.5 set delegate on CateogriesMenuViewController to self.
        categoriesMenuVC.delegate = self
        
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
    
    // Displays overlay of ChallangeVC when row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Creates an instance of ChallengeViewController
        guard let challengeVC: ChallengeViewController = self.storyboard!.instantiateViewController(withIdentifier: challengeViewControllerIdentifier) as? ChallengeViewController else { return }
        
        // Moves the instance of challengeVC on top of the view hierchy list and sizes the views overlay.
        challengeVC.view.frame = self.view.bounds
        challengeVC.willMove(toParent: self)
        self.view.addSubview(challengeVC.view)
        self.addChild(challengeVC)
        challengeVC.didMove(toParent: self)
    }
    
}


//MARK: - SearchBarDelegate


/// Reloads tableView if HistoryVC content has changed. 
extension HistoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}



// 4. Create an extension of HistoryViewController to conform to protocol you created and
//    conform to the protocl by adding the protocol method that passes in the category.

extension HistoryViewController: CategoriesMenuViewControllerDelegate {
   
    func handleSelectedCategory(category: Category) {
       
        print(category)
        
        // 6. set the selected category to the one that was selected from CategoriesVC that was passed into here by delegation pattern
        selectedCategory = category
    }
}
