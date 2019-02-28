//
//  Fortune+CoreDataProperties.swift
//  EarthLove
//
//  Created by Seth Watson on 2/14/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//
//

import Foundation
import CoreData


extension Fortune {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Fortune> {
        return NSFetchRequest<Fortune>(entityName: "Fortune")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var summary: String?
    @NSManaged  public var hasDisplayed: Bool
}
