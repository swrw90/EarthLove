//
//  UserDefaults+Extension.swift
//  EarthLove
//
//  Created by Seth Watson on 9/5/19.
//  Copyright © 2019 Seth Watson. All rights reserved.
//

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
}


