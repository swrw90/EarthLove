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
    
    
    class func insertToStore(from json: [JSON], in context: NSManagedObjectContext)  {
        _ = json.compactMap { challenge(from: $0, in: context) }
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save")
        }
    }
    
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
    
    /// Fetch Challenge using offset
    class func fetchRandomChallenge(with fetchRequest: NSFetchRequest<Challenge>, in context: NSManagedObjectContext) -> Challenge? {
        
        do {
            // Get length of context
//            let count = try context.count(for: fetchRequest)
//            print(count)
            // Get random number ranging from 0 and mangagedObjectContext count
//            let randomNumber = Int.random(in: 1 ..< count)
            
            // Set random number as fetchOffset property for fetchRequest
//            fetchRequest.fetchOffset = randomNumber
            let offset = fetchRequest.fetchOffset
            print("offset: \(offset)")
            let challenges =  try context.fetch(fetchRequest)
            print(challenges)
            
            print("challenge: \(challenges[offset])")
            return challenges[offset]
        } catch {
            print("error")
            return nil
        }
        
    }
    
    class func createRandomChallengeFetchRequest(with context: NSManagedObjectContext) -> NSFetchRequest<Challenge>? {
        
        do {
            // Create an instance of NSFetchRequest of Challenge type
            let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
            
            // Format fetchRequest to fetch Challenges with property isCompleted set to false
            fetchRequest.predicate = NSPredicate(format: "%K == NO", #keyPath(Challenge.isCompleted))
            
            // Use sortDescriptors to define the order of response from the fetchRequest, no order necessary, set to empty array
            fetchRequest.sortDescriptors = []
            
            let count = try context.count(for: fetchRequest)
            let randomNumber = Int.random(in: 0 ..< count)
            fetchRequest.fetchOffset = randomNumber
            
            
            return fetchRequest
        } catch {
            print("error")
            return nil
        }
    }
    
    
    //    class func getRandomIncompleteChallenge(in context: NSManagedObjectContext, with offset: Int) -> Challenge? {
    //        if let challenge = fetch(with: offset, in: context) {
    //            return challenge
    //        } else {
    //            return nil
    //        }
    //    }
    
    //    static var incompleteChallengeFetchRequest: NSFetchRequest<Challenge> {
    //    }
    //
    //    class func getContextCount(in context: NSManagedObjectContext) -> Int {
    //        do {
    //            return try context.count(for: incompleteChallengeFetchRequest)
    //        } catch {
    //            print("error")
    //            return 0
    //        }
}

//    class func createChallengeFetchOffset(with count: Int, using fetchRequest: NSFetchRequest<Challenge>) -> Int {
//
//        return offset
//
//    }






