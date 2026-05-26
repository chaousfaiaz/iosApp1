//
//  TimsRunApp.swift
//  TimsRun
//
//  Created by Kenneth Plumstead on 2025-09-18.
//

import SwiftUI

@main
struct TimsRunApp: App {
    // This is the entry point of my app.
    // I just tell it to show ContentView inside a WindowGroup (the main window).
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    // I’m keeping the list of people in memory using @State.
    // This way changes in the UI automatically update the data while the app is running.
    @State private var people: [Person] = SampleData.people

    var body: some View {
        // I use a TabView so I can have multiple sections of the app at the bottom.
        TabView {
            // First tab: People list
            PeopleListView(people: $people)
                .tabItem { Label("People", systemImage: "person.3") }

            // Second tab: New coffee run
            NewRunView(people: $people)
                .tabItem { Label("Run", systemImage: "bag") }
        }
    }
}

#Preview {
    ContentView()
}


