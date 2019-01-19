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
    
    private let categoryKey = "category"
    @NSManaged private var primitiveCategory: String
    
    var category: Category {
        get {
            willAccessValue(forKey: categoryKey)
            let category = Category(rawValue: primitiveCategory)
            didAccessValue(forKey: categoryKey)
            
            return category ?? .home
        }
        set {
            willChangeValue(forKey: categoryKey)
            primitiveCategory = newValue.rawValue
            didChangeValue(forKey: categoryKey)
        }
    }
    
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
            let isCompleted = json["isCompleted"] as? Bool,
            let category = Category(rawValue: json["category"] as? String ?? "") else { return nil }
        
        // fetch the challenge with identifier, if it doesn't exist create a new one.
        let challenge = fetch(with: identifier, in: context) ?? Challenge(context: context)
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
    
    /// Get count of all Challenge objects in context or count of all Challenge objects by filtered by category.
    ///
    /// - Parameters:
    ///     - context: NSManagedObjectContext used to get count of Challenge objects in context.
    /// - Returns: Returns an Int of all Challenge objects in context.
    
    class func getAllChallengesCount(in context: NSManagedObjectContext, with category: Category? = nil) -> Double? {
        var fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        
        do {
            if category != nil {
                fetchRequest = allChallengesFetchRequest(with: category!)
                let count = try Double(context.count(for: fetchRequest))
                print(count, "category count")
                return count
            } else {
                let count = try Double(context.count(for: fetchRequest))
                print(count, "all challenges count")
                return count
            }
        } catch {
            print("error") // switch to assert
            return nil
        }
    }
    
    /// Fetch a Challenge object using an identifier.
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
    
    /// Fetch a random incomplete Challenge using fetchRequest.
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
    
    /// Fetch all completed Challenges or all completed challenges filtered by category›.
    ///
    /// - Parameters:
    ///     - fetchRequest: Use NSFetchRequest to retrieve Challenges from context if it meets constraints of the fetchRequest.
    ///     - context: Retrieve Challenge objects contained within NSManagedObjectContext.
    /// - Returns: Returns an array of completed Challenge objects.
    
    class func fetchCompletedChallenges(from context: NSManagedObjectContext, category: Category? = nil) -> [Challenge] {
        
        var fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.sortDescriptors = [] // TODO: - Sort by date of completion.
        
        do {
            if category != nil {
                fetchRequest = completedChallengesFetchRequest(category: category!)
                
                guard let challengesByCategory = try? context.fetch(fetchRequest) else { return [] }
                
                return challengesByCategory
                
            } else {
                fetchRequest.predicate = isCompletedPredicate
                guard let challenges = try? context.fetch(fetchRequest) else { return [] }
                
                return challenges
            }
        }
    }
    
    
    /// Create a fetchRequest for all completed challenges or all completed challenges by category.
    class func completedChallengesFetchRequest(category: Category? = nil) -> NSFetchRequest<Challenge> {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.sortDescriptors = [] // Support ordering by completion date.
        
        if category != nil {
            fetchRequest.predicate = NSPredicate(format: "%K = YES AND category = %@", #keyPath(Challenge.isCompleted), category!.rawValue)
            
            return fetchRequest
        } else {
            fetchRequest.predicate = Challenge.isCompletedPredicate
            return fetchRequest
        }
    }
    
    /// Creates a fetch request for all challenges or all challenges by category.
    class func allChallengesFetchRequest(with category: Category? = nil) -> NSFetchRequest<Challenge> {
        let fetchRequest: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        fetchRequest.sortDescriptors = []
        if category != nil {
            fetchRequest.predicate = NSPredicate(format: "category = %@", category!.rawValue)
            return fetchRequest
        } else {
            return fetchRequest
        }
    }
    
    /// Creates a predicate to use to get only challenges that have not been completed.
    private static var isNotCompletedPredicate: NSPredicate {
        return NSPredicate(format: "%K = NO", #keyPath(Challenge.isCompleted))
    }
    
    /// Creates a predicate to use to get only challenges that have been completed.
    static var isCompletedPredicate: NSPredicate {
        return NSPredicate(format: "%K = YES", #keyPath(Challenge.isCompleted))
    }
    
}
