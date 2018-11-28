//
//  Challenge+CoreDataProperties.swift
//  EarthLove
//
//  Created by Seth Watson on 11/28/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//
//

import Foundation
import CoreData


extension Challenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var summary: String?
    @NSManaged public var category: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?

}
