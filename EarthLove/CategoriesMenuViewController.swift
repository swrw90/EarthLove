//
//  CategoriesMenu.swift
//  EarthLove
//
//  Created by Seth Watson on 1/25/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

private let categoryCell = "categoryCell"

protocol CategoriesMenuViewControllerDelegate: AnyObject {
    func handleSelectedCategory(category: Category)
    
}

class CategoriesMenuViewController: UITableViewController {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        
        let cellNib = UINib(nibName: String(describing: CategoryCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: categoryCell)
        
    }
    
    weak var delegate: CategoriesMenuViewControllerDelegate?
    
    
    // MARK - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Category.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath) as? CategoryCell else { return UITableViewCell() }
        
        cell.categoryLabel.text = Category.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.handleSelectedCategory(category: Category.allCases[indexPath.row])

        
        // Remove categoriesMenuVC from view stack.
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
