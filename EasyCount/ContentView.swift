//
//  ContentView.swift
//  EasyCount
//
//  Created by Zoë Pfister on 03.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import SwiftUI

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
                    leading: EditButton(),
                    trailing: Button(
                        action: {
                            withAnimation { Counter.create(in: self.viewContext) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Counter.timestamp, ascending: true)],
        animation: .default)
    var counters: FetchedResults<Counter>

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(counters, id: \.self) { event in
                NavigationLink(
                    destination: DetailView(counter: event, counterDetails: event.counterDetailsArray)
                ) {
                    Text("\(event.timestamp!, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                self.counters.delete(at: indices, from: self.viewContext)
            }
        }
    }
}

struct DetailView: View {
    @ObservedObject var counter: Counter
    @State var counterDetails: [CounterDetail]

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(counterDetails, id: \.self) { detail in
                   DetailRow(detail: detail)
            }
            .onDelete { indices in
                self.counterDetails.delete(at: indices, from: self.viewContext)
            }
        }
        .navigationBarTitle(Text(self.counter.wrappedName))
        .navigationBarItems(
            trailing: Button(
                action: {
                    withAnimation {
                        let newCounterDetail = CounterDetail.create(in: self.viewContext, with: self.counter)
                        self.counterDetails.append(newCounterDetail)
                    }
                }
            ) {
                Image(systemName: "plus")
        })
    }
}

struct DetailRow: View {
    @ObservedObject var detail: CounterDetail
    @Environment(\.managedObjectContext)
    var viewContext
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Stepper("\(detail.wrappedName): \(detail.count)", onIncrement: {
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
