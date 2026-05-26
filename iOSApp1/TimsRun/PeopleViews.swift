//
//  PeopleViews.swift
//  TimsRun
//
//  Created by Kenneth Plumstead on 2025-09-18.
//

import SwiftUI

struct PeopleListView: View {
    // I pass in the list of people as a binding so changes update back in ContentView.
    @Binding var people: [Person]
    // This tracks if I’m showing the add person sheet or not.
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            // I show all the people in a list.
            List {
                ForEach(people) { person in
                    // Tapping on a person opens the edit screen for them.
                    NavigationLink(person.name) {
                        EditPersonView(person: binding(for: person))
                    }
                }
                // I also allow swipe to delete from the list.
                .onDelete(perform: delete)
            }
            .navigationTitle("People")
            .toolbar {
                // Plus button to add a new person.
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Add Person")
                }
            }
            // When showingAdd is true, I pop up the AddPersonView in a sheet.
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    AddPersonView { newPerson in
                        // Once save is tapped, I add the new person and close the sheet.
                        people.append(newPerson)
                        showingAdd = false
                    }
                }
            }
        }
    }

    // This handles deleting rows from the list.
    private func delete(at offsets: IndexSet) { people.remove(atOffsets: offsets) }

    // This finds the binding for a specific person inside the array
    // so EditPersonView can update the right element.
    private func binding(for person: Person) -> Binding<Person> {
        guard let index = people.firstIndex(where: { $0.id == person.id }) else { return .constant(person) }
        return $people[index]
    }
}

struct AddPersonView: View {
    // I only need a name field to create a person.
    @State private var name: String = ""
    let onSave: (Person) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
            }
        }
        .navigationTitle("New Person")
        .toolbar {
            // Cancel just dismisses the sheet.
            ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
            // Save creates a new Person and calls back to the list.
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") { onSave(Person(name: name)) }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}

struct EditPersonView: View {
    // I edit a person directly through the binding from the list.
    @Binding var person: Person
    // I use a temporary order so I don’t overwrite until I press Save.
    @State private var tempOrder: DrinkOrder = .init()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $person.name)
                    .textInputAutocapitalization(.words)
            }
            Section("Usual Order") {
                // Here’s the form for editing their saved usual order.
                TextField("Drink name", text: $tempOrder.drinkName)
                Picker("Size", selection: $tempOrder.size) {
                    ForEach(DrinkOrder.Size.allCases, id: \.self) { s in
                        Text(s.rawValue.capitalized).tag(s)
                    }
                }
                Stepper("Milk: \(tempOrder.milk)", value: $tempOrder.milk, in: 0...3)
                Stepper("Sugar: \(tempOrder.sugar)", value: $tempOrder.sugar, in: 0...3)
                TextField("Notes", text: $tempOrder.notes, axis: .vertical)
            }
            if person.usual != nil {
                // If the person already has a usual, I let myself clear it out.
                Section {
                    Button(role: .destructive) {
                        person.usual = nil
                        dismiss()
                    } label: { Label("Remove Usual", systemImage: "trash") }
                }
            }
        }
        .navigationTitle(person.name.isEmpty ? "Edit Person" : person.name)
        .toolbar {
            // Save applies the temp order back to the person.
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    person.usual = tempOrder
                    dismiss()
                }
            }
        }
        // When the view appears, I preload their existing usual into tempOrder.
        .onAppear { if let u = person.usual { tempOrder = u } }
    }
}
