//
//  UserDefaults+Extension.swift
//  EarthLove
//
//  Created by Seth Watson on 9/5/19.
//  Copyright © 2019 Seth Watson. All rights reserved.

import Foundation

extension UserDefaults {
    func register(with appDefaults: AppDefaults) {
        UserDefaults.standard.register(defaults: [appDefaults.defaultKeys: appDefaults.registerValue])
    }
    
    func setValue(for appDefaultsBool: AppDefaultsBool) {
        UserDefaults.standard.set(appDefaultsBool.value, forKey: appDefaultsBool.defaultKeys)
    }
    
    func setValue(for appDefaultsInt: AppDefaultsInt) {
        UserDefaults.standard.set(appDefaultsInt.value, forKey: appDefaultsInt.defaultKeys)
    }
    
    func setValue(for appDefaultsDate: AppDefaultsDate) {
        UserDefaults.standard.set(appDefaultsDate.value, forKey: appDefaultsDate.defaultKeys)
    }
    
    func value(for appDefaultsInt: AppDefaultsInt) -> Int {
        return UserDefaults.standard.integer(forKey: appDefaultsInt.defaultKeys)
    }
    
    func value(for appDefaultsBool: AppDefaultsBool) -> Bool {
        return UserDefaults.standard.bool(forKey: appDefaultsBool.defaultKeys)
    }
    
    func value(for appDefaultsDate: AppDefaultsDate) -> Date {
        return UserDefaults.standard.value(forKey: appDefaultsDate.defaultKeys) as? Date ?? Date()
    }
    
    
    class func setUpForFirstLaunch() {
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
            //                UserDefaults.standard.register(defaults: ["hasCompletedAChallenge" : false])
            UserDefaults.standard.register(with: AppDefaultsBool.hasCompletedChallenge(false))
        }
    }
}


