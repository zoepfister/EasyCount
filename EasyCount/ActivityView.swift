//
//  ActivityView.swift
//  EasyCount
//
//  Created by Zoë Pfister on 05.01.20.
//  Copyright © 2020 Zoë Pfister. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}
