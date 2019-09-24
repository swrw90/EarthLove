//
//  AppDefaults.swift
//  EarthLove
//
//  Created by Seth Watson on 9/5/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

import Foundation

protocol AppDefaults {
    var defaultKeys: String { get }
    var registerValue: Any { get }
}

enum AppDefaultsBool: AppDefaults {
    case firstLaunch(Bool?)
    case hasCompletedChallenge(Bool?)
    
    /// Key to be used with UserDefaults to pull out or insert values from disk.
    var defaultKeys: String {
        switch self {
        case .firstLaunch(_): return "firstLaunchKey"
        case .hasCompletedChallenge(_): return "hasCompletedChallengeKey"
        }
    }
    
    /// Actual value that will be stored in the disk using UserDefaults.
    var value: Bool? {
        switch self {
        case .firstLaunch(let booleanValue), .hasCompletedChallenge(let booleanValue): return booleanValue
        }
    }
    
    
    /// Value only used in conjunction with `UserDefaults` `register(value:)` method.
    var registerValue: Any {
        switch self {
        case .firstLaunch(_): return true
        case .hasCompletedChallenge(_): return false
        }
    }
}

enum AppDefaultsInt: AppDefaults {
    case skipCount(Int?)
    case numberOfTimesCompleted(Int?)
    case countUntilFortuneDisplays(Int?)
    case challengeIdentifier(Int?)
    
    var defaultKeys: String {
        switch self {
        case .skipCount(_): return "skipCountKey"
        case .numberOfTimesCompleted(_): return "numberOfTimesCompletedKey"
        case .countUntilFortuneDisplays(_): return "countUntilFortuneDisplaysKey"
        case .challengeIdentifier(_): return "challengeIdentifierKey"
        }
    }
    
    
    var value: Int? {
        switch self {
        case .skipCount(let integerValue), .numberOfTimesCompleted(let integerValue), .countUntilFortuneDisplays(let integerValue), .challengeIdentifier(let integerValue): return integerValue
        }
    }
    
    var registerValue: Any {
        switch self {
        case .skipCount(_), .numberOfTimesCompleted(_), .countUntilFortuneDisplays(_), .challengeIdentifier(_): return 0
        }
    }
}

enum AppDefaultsDate: AppDefaults {
    case creationTime(Date?)
    
    var defaultKeys: String {
        switch self {
        case .creationTime(_): return "creationTimeKey"
        }
    }
    
    var value: Date? {
        switch self {
        case .creationTime(let date): return date
        }
    }
    
    var registerValue: Any {
        switch self {
        case .creationTime(_): return Date()
        }
    }
}
