//
//  manifestApp.swift
//  manifest
//
//  Created by Adrian on 28/5/23.
//

import SwiftUI

@main
struct manifestApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
