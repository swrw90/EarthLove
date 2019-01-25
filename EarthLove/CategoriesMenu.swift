//
//  CategoriesMenu.swift
//  EarthLove
//
//  Created by Seth Watson on 1/25/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import UIKit

class CategoriesMenu: UITableViewController {

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
            return cell
    }
}
