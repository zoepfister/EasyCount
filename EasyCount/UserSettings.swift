//
//  UserSettings.swift
//  EasyCount
//
//  Created by Zoë Pfister on 05.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//
//  Credit to https://stackoverflow.com/questions/56822195/how-do-i-use-userdefaults-with-swiftui
//

import Foundation
import Combine

final class UserSettings: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    // Defines the List padding in the content and detailviews
    @UserDefault("ListPadding", defaultValue: 1.0)
    var listPadding: Float {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Defines how many steps should be counted when tapping + / - on each detailcounter
    @UserDefault("StepCount", defaultValue: 1)
    var stepCount: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Defines if the program should start counting from 0 or not when creating a new detailcounter
    @UserDefault("StartCountingAtZero", defaultValue: false)
    var startCountingAtZero: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
