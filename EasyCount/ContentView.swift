//
//  ContentView.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import CoreData
import Foundation
import SwiftUI
import Combine

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext

    @State var isPreferencesPresented = false

    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text("Counters"))
                .navigationBarItems(trailing: Button(
                    action: {
                        self.isPreferencesPresented = true
                    }
                ) {
                    Image(systemName: "gear")
                })
        }
        // Show the Preference View sheet
        .sheet(isPresented: $isPreferencesPresented,
               onDismiss: {
                   self.isPreferencesPresented = false
               },
               content: {
                   PreferenceView(showingPreferenceView: self.$isPreferencesPresented)
        })
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Environment(\.managedObjectContext)
    var viewContext

    // User settings
    @ObservedObject private var settings = UserSettings()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.timestamp, ascending: true)],
        animation: .default)
    var counters: FetchedResults<Counter>

    @State private var newText: String = ""

    private func createCounter() {
        if !newText.isEmpty {
            Counter.create(in: viewContext, with: newText)
            newText = ""
        }
    }

    var body: some View {
        List {
            ForEach(counters, id: \.self) { event in
                NavigationLink(
                    destination: CounterDetailView(filter: event)
                ) {
                    VStack(alignment: .leading) {
                        CustomCountersTextfield(placeholder: Text(event.wrappedName), counter: event)
                        Text("\(event.timestamp!, formatter: dateFormatter)")
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }.padding(CGFloat(self.settings.listPadding))
                }
            }.onDelete { indices in
                self.counters.delete(at: indices, from: self.viewContext)
            }
            HStack {
                TextField("Enter a new counter name", text: $newText, onCommit: {
                    self.createCounter()
                    })
                Button(
                    action: {
                        withAnimation {
                            self.createCounter()
                            UIApplication.shared.windows.forEach({$0.endEditing(false)})
                        }
                    }
                ) {
                    Image(systemName: "plus")
                    }.accessibility(label: Text("Add counter"))
            }.padding(CGFloat(self.settings.listPadding))
        }.padding(CGFloat(self.settings.listPadding)).modifier(AdaptsToSoftwareKeyboard())
    }
}

// Struct that scrolls the view as far as the keyboard will hide the screen such that text is visible
// https://stackoverflow.com/questions/56716311/how-to-show-complete-list-when-keyboard-is-showing-up-in-swiftui
struct AdaptsToSoftwareKeyboard: ViewModifier {

    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.currentHeight)
            .edgesIgnoringSafeArea(self.currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        // Adding 50.0 extra just to give it some padding
        .map { $0.height + 50.0 }

    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }

    private func subscribeToKeyboardEvents() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.currentHeight, on: self)
    }
}

struct CustomCountersTextfield: View {
    var placeholder: Text
    @ObservedObject var counter: Counter
    @State var editedText: String = ""

    var body: some View {
        ZStack(alignment: .leading) {
            if editedText.isEmpty { placeholder }
            TextField("", text: $editedText, onCommit: {
                self.counter.name = self.editedText
            }).onTapGesture {
                self.editedText = self.counter.wrappedName
            }
            // Hardcoding this for now. TODO: should be changed to some relative screen size
            .frame(maxWidth: CGFloat(200.0))
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
