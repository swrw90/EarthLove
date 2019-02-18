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
   
    /// Return a hydrated Fortune object from json to be saved into context.
    ///
    /// - Parameters:
    ///     - json: Array of json Fortune objects.
    ///     - context: NSManagedObjectContext to be used to modify Fortune objects.
    /// - Returns: Returns a hydrated Fortune object.
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
    
    /// Fetch a Fortune object using an identifier.
    ///
    /// - Parameters:
    ///     - identifier: Use the identifiers property on the Fortune object to retrieve object by its ID.
    ///     - context: NSManagedObjectContext used to retrieve Fortune object from.
    /// - Returns: Returns a specific Fortune object retrieved by its identifier.
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
    
    class func getAllFortunesCount(in context: NSManagedObjectContext) -> Int? {
        var fetchRequest: NSFetchRequest<Fortune> = Fortune.fetchRequest()
        return try? context.count(for: fetchRequest)
    }
    
//    class func getRandomFortune()
}

