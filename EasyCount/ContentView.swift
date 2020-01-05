//
//  ContentView.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import SwiftUI
import Foundation
import CoreData

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    

    var body: some View {
        NavigationView {
            MasterView()
        
                .navigationBarTitle(Text("Counters"))
                .navigationBarItems(
                    trailing: EditButton()
                )
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.timestamp, ascending: true)],
        animation: .default)
    var counters: FetchedResults<Counter>
    
    @State private var newText: String = ""
    
    var body: some View {
        List {
            ForEach(counters, id: \.self) { event in
                NavigationLink(
                    destination: DetailView(filter: event)
                ) {
                    VStack(alignment: .leading) {
                        Text("\(event.wrappedName)")
                        Text("\(event.timestamp!, formatter: dateFormatter)")
                            .fontWeight(.light)
                            .font(.system(size: 14))
                    }
                    
                }
            }.onDelete { indices in
                self.counters.delete(at: indices, from: self.viewContext)
            }
            HStack {
                TextField("Enter a new counter name", text: $newText)
                Button(
                    action: {
                        withAnimation {
                            Counter.create(in: self.viewContext, with: self.newText)
                            self.newText = ""
                        }
                    }
                ) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct DetailView: View {
    var counter: Counter
    @State private var newText: String = ""
    
    var fetchRequest: FetchRequest<CounterDetail>
    var counterDetails: FetchedResults<CounterDetail>{fetchRequest.wrappedValue}
    
    @Environment(\.managedObjectContext)
    var viewContext
    
    // Convenience Init to allow a fetch request using a filter predicate (in this case, the current
    // counter. Source:
    // https://www.hackingwithswift.com/quick-start/ios-swiftui/dynamically-filtering-fetchrequest-with-swiftui
    init(filter: Counter) {
        fetchRequest = FetchRequest(
        entity: CounterDetail.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \CounterDetail.name, ascending: true)],
        predicate: NSPredicate(format: "counter == %@", filter),
        animation: .default)
        self.counter = filter
    }
    
    var body: some View {
        List {
            ForEach(counterDetails, id: \.self) { detail in
                   DetailRow(detail: detail)
            }
            .onDelete { indices in
                self.counterDetails.delete(at: indices, from: self.viewContext)
            }
            
            HStack {
                TextField("Enter a counter name", text: $newText)
                Button(
                    action: {
                        withAnimation {
                            if self.newText != "" {
                                let newCounter = CounterDetail.create(in: self.viewContext)
                                newCounter.counter = self.counter
                                newCounter.name = self.newText
                                self.newText = ""
                            }
                        }
                    }
                ) {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationBarTitle(Text(self.counter.wrappedName))
        .navigationBarItems(trailing: EditButton())
    }
}

struct DetailRow: View {
    @ObservedObject var detail: CounterDetail
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(detail.wrappedName)").frame(maxWidth: .infinity, alignment: .leading)
            Text("\(detail.count)")
                .fontWeight(.heavy)
                .frame(maxWidth: .some(CGFloat(50.0)), alignment: .trailing)
            Stepper("", onIncrement: {
                self.detail.countUp()
                // edit your proposed progress amount here
                print("Adding to age")
            }, onDecrement: {
                self.detail.countDown()
                // edit your proposed progress amount here
                print("Subtracting from age")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}

