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
                    destination: DetailView(counter: event, counterDetails: event.counterDetailsArray)
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
    @ObservedObject var counter: Counter
    @State var counterDetails: [CounterDetail]
    @State private var newText: String = ""

    @Environment(\.managedObjectContext)
    var viewContext

    var body: some View {
        List {
            ForEach(counterDetails, id: \.self) { detail in
                   DetailRow(detail: detail)
            }
            .onDelete { indices in
                self.counterDetails.delete(at: indices, from: self.viewContext)
                self.counterDetails.remove(atOffsets: indices)
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
                                self.counterDetails.append(newCounter)
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

// https://stackoverflow.com/questions/56726663/how-to-add-a-textfield-to-alert-in-swiftui

private func alert(with moc: NSManagedObjectContext, title: String = "Title", message: String?) -> CounterDetail? {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addTextField() { textField in
        textField.placeholder = "Enter some text"
    }
    
    let newCounterDetail: CounterDetail = CounterDetail.create(in: moc)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
        
    })
    alert.addAction(UIAlertAction(title: "Add", style: .default) { _ in
        newCounterDetail.name = alert.textFields![0].text
    
    })
    showAlert(alert: alert)
    
    return newCounterDetail
}

func showAlert(alert: UIAlertController) {
    if let controller = topMostViewController() {
        controller.present(alert, animated: true, completion: nil)
    }
}

private func keyWindow() -> UIWindow? {
    return UIApplication.shared.connectedScenes
    .filter {$0.activationState == .foregroundActive}
    .compactMap {$0 as? UIWindowScene}
    .first?.windows.filter {$0.isKeyWindow}.first
}

private func topMostViewController() -> UIViewController? {
    guard let rootController = keyWindow()?.rootViewController else {
        return nil
    }
    return topMostViewController(for: rootController)
}

private func topMostViewController(for controller: UIViewController) -> UIViewController {
    if let presentedController = controller.presentedViewController {
        return topMostViewController(for: presentedController)
    } else if let navigationController = controller as? UINavigationController {
        guard let topController = navigationController.topViewController else {
            return navigationController
        }
        return topMostViewController(for: topController)
    } else if let tabController = controller as? UITabBarController {
        guard let topController = tabController.selectedViewController else {
            return tabController
        }
        return topMostViewController(for: topController)
    }
    return controller
}
