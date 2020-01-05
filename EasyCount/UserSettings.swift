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

    @UserDefault("ListPadding", defaultValue: 1.0)
    var listPadding: Float {
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
