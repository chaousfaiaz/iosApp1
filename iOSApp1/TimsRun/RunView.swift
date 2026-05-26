//
//  RunView.swift
//  TimsRun
//
//  Created by Kenneth Plumstead on 2025-09-18.
//

import SwiftUI

struct NewRunView: View {
    // I bring in the people array as a binding so changes flow both ways.
    @Binding var people: [Person]
    
    // I’m keeping track of which people are selected by storing their IDs in a set.
    @State private var selectedIDs: Set<UUID> = []

    // This computed property gives me just the people that are currently selected.
    private var selectedPeople: [Person] { people.filter { selectedIDs.contains($0.id) } }

    var body: some View {
        NavigationStack {
            VStack {
                // This shows the full list of people I can pick for the run.
                List(people) { p in
                    Button {
                        // When I tap a person, I toggle their selection on or off.
                        if selectedIDs.contains(p.id) {
                            selectedIDs.remove(p.id)
                        } else {
                            selectedIDs.insert(p.id)
                        }
                    } label: {
                        HStack {
                            Text(p.name)
                            Spacer()
                            // If a person is selected, I show a checkmark on the right.
                            if selectedIDs.contains(p.id) {
                                Image(systemName: "checkmark").foregroundStyle(.tint)
                            }
                        }
                    }
                }

                Divider().padding(.horizontal)

                // This shows the summary of the orders for the selected people.
                VStack(alignment: .leading, spacing: 6) {
                    Text("Order Summary").font(.headline)
                    
                    // If nothing is selected, I tell the user.
                    if selectedPeople.isEmpty {
                        Text("No people selected yet.").foregroundStyle(.secondary)
                    } else {
                        // Otherwise I loop through the selected people and show their usual orders.
                        ForEach(selectedPeople) { person in
                            if let u = person.usual {
                                Text("• \(person.name): \(u.size.rawValue.capitalized) \(u.drinkName)  milk \(u.milk)  sugar \(u.sugar)\(u.notes.isEmpty ? "" : " (\(u.notes))")")
                                    .font(.callout)
                            } else {
                                // If they don’t have a usual saved, I note that too.
                                Text("• \(person.name): (no usual saved)")
                                    .font(.callout)
                            }
                        }
                    }
                }
                // I stretch the summary to full width and give it some padding.
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("New Run")
        }
    }
}

