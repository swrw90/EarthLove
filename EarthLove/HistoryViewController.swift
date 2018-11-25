//
//  SecondViewController.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var searchResults = [SearchResult]()
    
    //MARK: - Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
    }
}


//MARK: - TableView Data Source

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchResultsCell"
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if searchResults.count == 0 {
            cell.textLabel!.text = ("Nothing Found")
            cell.detailTextLabel!.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.textLabel!.text = searchResult.title
            cell.detailTextLabel!.text = searchResult.subTitle
        }
        
        let searchResult = searchResults[indexPath.row]
        cell.textLabel!.text = searchResult.title
        cell.detailTextLabel!.text = searchResult.subTitle
        return cell
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
        tableView.reloadData()
    }
 
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
