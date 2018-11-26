//
//  SecondViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    var hasSearched = false
    var searchResults = [SearchResult]()
    
    
    //MARK: - TableView Cell Identifiers
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
    }
    
    //MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        tableView.rowHeight = 80
        let cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
    }
}


//MARK: - TableView Data Source

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        
        if searchResults.count == 0 {
            cell.titleLabel.text = ("Nothing Found")
            cell.subTitleLabel.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.title
            cell.subTitleLabel.text = searchResult.subTitle
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
    
}


//MARK: - SearchBarDelegate

extension HistoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchResults = []
        for i in 0...2 {
            let searchResult = SearchResult()
            print(searchResult.title)
            searchResult.title = String(format: "Fake Result %d for", i)
            searchResult.subTitle = searchBar.text!
            searchResults.append(searchResult)
        }
        
        hasSearched = true
        tableView.reloadData()
    }
 
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
