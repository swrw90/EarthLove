//
//  AppDelegate.swift
//  EarthLove
//
//  Created by Seth Watson on 11/19/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EarthLove")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could not load data store: \(error)")
            } 
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    
    // MARK: - Core Data Saving support
    
    /// Saves context if it has any changes.
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Helper Methods
    
    // Set styling for SearchBar in HistoryVC.
    func customizeAppearance() {
        let barTintColor = UIColor(red: 20/255, green: 80/255, blue: 20/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor
        
        window!.tintColor = UIColor(red: 10/255, green: 80/255, blue: 20/255, alpha: 1)
    }
    
    
    // MARK: - User Notification Delegates.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        
        // Notification Authorization
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            if granted {
                center.delegate = self
                print("Notifications permission granted.")
            } else {
                print("Notifications permission denied.")
            }
        }
        
        // Assigns managedObjectContext to each view using tabViewContrrolers and navController.
        let tabController = window!.rootViewController as! UITabBarController
        if let tabViewControllers = tabController.viewControllers {
            
            var navController = tabViewControllers[0] as! UINavigationController
            let controller1 = navController.viewControllers.first as! ChallengeViewController
            controller1.managedObjectContext = managedObjectContext
            
            navController = tabViewControllers[1] as! UINavigationController
            let controller2 = navController.viewControllers[0] as! StatsViewController
            controller2.managedObjectContext = managedObjectContext
            
            navController = tabViewControllers[2] as! UINavigationController
            let controller3 = navController.viewControllers[0] as! HistoryViewController
            controller3.managedObjectContext = managedObjectContext
            
        }
        
        // If it's the apps first launch call functions to parse challenge and fortune json.
        if isFirstLaunch {
            parseChallengeJSON()
            parseFortuneJSON()
        } else {
            print("App has already previously launched.")
        }
        
        return true
    }
    
    // Uses UserDefaults to determine if the app has previously launched. If it's first launch, set UserDefault initial values.
    var isFirstLaunch: Bool {
        let defaults = UserDefaults.standard
        
        if let firstLaunch = defaults.string(forKey: "firstLaunch") {
            print("App has already launched : \(firstLaunch)")
            
            return false
        } else {
            print("App launched for first time")
            defaults.set(true, forKey: "firstLaunch")
            
            // Register the initial skipCount value from ChallangeVC to UserDefaults.
            if UserDefaults.standard.object(forKey: "skipCount") == nil {
                UserDefaults.standard.register(defaults: ["skipCount" : 0])
            }
            
            // Register the initial numberOfTimesCompleted value from ChallengeVC to UserDefaults.
            if UserDefaults.standard.object(forKey: "numberOfTimesCompleted") == nil {
                UserDefaults.standard.register(defaults: ["numberOfTimesCompleted" : 0])
            }
            
            // Register the initial countUntilFortuneDisplays value from ChallengeVC to UserDefaults.
            if UserDefaults.standard.object(forKey: "countUntilFortuneDisplays") == nil {
                UserDefaults.standard.register(defaults: ["countUntilFortuneDisplays" : 0])
            }
            
            // Register initial Challenge for ChallengeVC to UserDefaults
            UserDefaults.standard.register(defaults: ["identifier" : 1])
            
            // Set initial Challenge creation time.
            // TODO: - Move this logic outside of App Delegate.
            UserDefaults.standard.set(Date(), forKey: "creationTime")
            
            // Register the hasCompletedAChallenge initial value for from ChallengeVC to UserDefaults.
            if UserDefaults.standard.object(forKey: "hasCompletedAChallenge") == nil {
                UserDefaults.standard.register(defaults: ["hasCompletedAChallenge" : false])
            }
            return true
        }
    }
    
    // Handles parsing of challenge json and saves it to context.
    private func parseChallengeJSON() {
        // Find path to json, make path into URL, get data from json, parse json data.
        // TODO: - Use conditional to determine if app has already loaded previously, if so do ot repeat json parse.
        if let path = Bundle.main.path(forResource: "challengeData", ofType: "json") {
            do {
                let pathURL = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: pathURL)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [JSON] {
                    Challenge.insertToStore(from: jsonResult, in: managedObjectContext)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // Handles parsing of Fortune json and saves it to context.
    private func parseFortuneJSON() {
        // Find path to json, make path into URL, get data from json, parse json data.
        // TODO: - Use conditional to determine if app has already loaded previously, if so do ot repeat json parse.
        
        DispatchQueue.global(qos: .background).async {
            if let path = Bundle.main.path(forResource: "fortuneData", ofType: "json") {
                do {
                    let pathURL = URL(fileURLWithPath: path)
                    let data = try Data(contentsOf: pathURL)
                    DispatchQueue.main.async {
                        do {
                            try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        } catch {
                            print(error)
                        }
                        
                        guard let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [JSON], let json = jsonResult else { return }
                        Fortune.insertToStore(from: json, in: self.managedObjectContext)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
}
