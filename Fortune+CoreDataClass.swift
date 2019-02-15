//
//  Fortune+CoreDataClass.swift
//  EarthLove
//
//  Created by Seth Watson on 2/14/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Fortune)
public class Fortune: NSManagedObject {
    
    class func insertToStore(from json: [JSON], in context: NSManagedObjectContext)  {
        _ = json.compactMap { fortune(from: $0, in: context) }
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save")
        }
    }
    
    class func fortune(from json: JSON, in context: NSManagedObjectContext) -> Fortune? {
        // Make sure these properties are coming from the json. If it's not Fortune cannot exist
        // so return nil.
        guard let identifier = json["identifier"] as? Int64,
            let isCompleted = json["isCompleted"] as? Bool
        else { return nil }
        
        // Fetch the fortune with identifier, if it doesn't exist create a new one.
        let fortune = fetch(with: identifier, in: context) ?? Fortune(context: context)
        let summary = json["summary"] as? String
        
        // Hydrate
        fortune.identifier = identifier
        fortune.isCompleted = isCompleted
        fortune.summary = summary
        
        print("\(fortune)")
        
        return fortune
    }
    
    class func fetch(with identifier: Int64, in context: NSManagedObjectContext) -> Fortune? {
        let fetchRequest: NSFetchRequest<Fortune> = Fortune.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Fortune.identifier), identifier)
        fetchRequest.fetchLimit = 2
        
        do {
            let fortunes = try context.fetch(fetchRequest)
            return fortunes.first
        } catch {
            print("error") // switch to assert
            return nil
        }
    }
}

