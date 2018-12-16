//
//  Challenge+CoreDataClass.swift
//  EarthLove
//
//  Created by Seth Watson on 11/28/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//
//

import Foundation
import CoreData

typealias JSON = [String: Any]

@objc(Challenge)
public class Challenge: NSManagedObject {
    
    /// Map challenges from json and save into context.
    ///
    /// - Parameters:
    ///     - json: Array of json to be parsed.
    ///     - context: NSManagedObjectContext to be used to insert the Challenge objects.
    class func insertToStore(from json: [JSON], in context: NSManagedObjectContext)  {
        _ = json.compactMap { challenge(from: $0, in: context) }
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save")
        }
    }
    
    /// Return a hydrated Challenge object from json to be saved into context.
    ///
    /// - Parameters:
    ///     - json: Array of json Challenge objects.
    ///     - context: NSManagedObjectContext to be used to modify Challenge objects.
    /// - Returns: Returns a hydrated Challenge object.
    
    class func challenge(from json: JSON, in context: NSManagedObjectContext) -> Challenge? {
        // Make sure these properties are coming from the json. If it's not Challenge cannot exist
        // so return nil.
        guard let identifier = json["identifier"] as? Int64,
            let isCompleted = json["isCompleted"] as? Bool else { return nil }
        
        // fetch the challenge with identifier, if it doesn't exist create a new one.
        let challenge = fetch(with: identifier, in: context) ?? Challenge(context: context)
        
        let category = json["category"] as? String
        let summary = json["summary"] as? String
        let title = json["title"] as? String
        
        // Hybdrate
        challenge.identifier = identifier
        challenge.isCompleted = isCompleted
        
        challenge.category = category
        challenge.summary = summary
        challenge.title = title
        
        return challenge
    }
    
    /// Fetch the Challenge object with identifier.
    ///
    /// - Parameters:
    ///     - identifier: Use the identifiers property on the Challenge object to retrieve object by its ID.
    ///     - context: NSManagedObjectContext used to retrieve Challenge object from.
    /// - Returns: Returns a specific Challenge object retrieved by its identifier.
    
    class func fetch(with identifier: Int64, in context: NSManagedObjectContext) -> Challenge? {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Challenge.identifier), identifier)
        fetchRequest.fetchLimit = 2
        
        do {
            let challenges = try context.fetch(fetchRequest)
            return challenges.first
        } catch {
            print("error") // switch to assert
            return nil
        }
    }
    
    /// Fetch a random Challenge using fetchRequest.
    ///
    /// - Parameters:
    ///     - fetchRequest: Use NSFetchRequest to retrieve Challenge from context if it meets constraints of the fetchRequest.
    ///     - context: Retrieve Challenge object contained within NSManagedObjectContext.
    /// - Returns: Returns a random Challenge object.
    class func fetchRandomChallenge(from context: NSManagedObjectContext) -> Challenge? {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.predicate = isNotCompletedPredicate
        fetchRequest.sortDescriptors = []
        
        do {
            let challenges =  try context.fetch(fetchRequest)
            let challenge = challenges.randomElement()
            return challenge
        } catch {
            print("error")
            return nil
        }
    }
    
    private static var isNotCompletedPredicate: NSPredicate {
        return NSPredicate(format: "%K = NO", #keyPath(Challenge.isCompleted))
    }
    
    
    
    /// Create Fetch Request to be used for getting a random Challenge
    ///
    /// - Parameters:
    ///     - context: NSMangedObjectContext to be used getting a count of stored objects.
    /// - Returns: NSFetchRequest with constraints to be used when performing fetch for Challenge objects in context.
    
//    class func createRandomChallengeFetchRequest(with context: NSManagedObjectContext) -> NSFetchRequest<Challenge>? {
//
//        do {
//            // Create an instance of NSFetchRequest of Challenge type
//            let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
//
//            // Format fetchRequest to fetch Challenges with property isCompleted set to false
//            fetchRequest.predicate = NSPredicate(format: "%K == NO", #keyPath(Challenge.isCompleted))
//
//            // Use sortDescriptors to define the order of response from the fetchRequest, no order necessary, set to empty array
//            fetchRequest.sortDescriptors = []
//
//            let count = try context.count(for: fetchRequest)
//            let randomNumber = Int.random(in: 0 ..< count)
//            fetchRequest.fetchOffset = randomNumber
//
//
//            return fetchRequest
//        } catch {
//            print("error")
//            return nil
//        }
//    }
}
