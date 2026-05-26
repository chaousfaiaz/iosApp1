//
//  Models.swift
//  TimsRun
//
//  Created by Kenneth Plumstead on 2025-09-18.
//

import Foundation

// This struct represents a single drink order.
// I make it Identifiable so I can use it easily in ForEach/List,
// and Equatable so SwiftUI knows when it changes.
struct DrinkOrder: Identifiable, Equatable {
    // I use an enum for size so I can have a Picker in the UI with fixed choices.
    enum Size: String, CaseIterable { case small, medium, large, extraLarge }

    let id = UUID()             // each order gets a unique ID
    var drinkName: String = "Coffee"
    var size: Size = .medium
    var milk: Int = 0           // number of milk portions
    var sugar: Int = 0          // number of sugar portions
    var notes: String = ""      // optional notes for extras
}

// This struct represents a person.
// They can have a name and an optional usual order.
struct Person: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var usual: DrinkOrder? = nil
}

// I use this enum just to hold some sample data
// so the app doesn’t look empty the first time it runs.
enum SampleData {
    static let people: [Person] = [
        Person(name: "Alex", usual: DrinkOrder(drinkName: "Latte", size: .medium, milk: 0, sugar: 0, notes: "Oat milk")),
        Person(name: "Zee",  usual: DrinkOrder(drinkName: "Iced Coffee", size: .large, milk: 1, sugar: 1)),
        Person(name: "Ken",  usual: DrinkOrder(drinkName: "Double Double", size: .medium, milk: 2, sugar: 2))
    ]
}

