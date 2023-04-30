//
//  EmbeddedPythonSpikeApp.swift
//  EmbeddedPythonSpike
//
//  Created by Alexis Rondeau on 20.04.23.
//

import SwiftUI


@main
struct EmbeddedPythonSpikeApp: App {
    @StateObject var embeddedPython = EmbeddedPython()
    
    var body: some Scene {
        WindowGroup() {
            ContentView()
                .environmentObject(embeddedPython)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            TextFormattingCommands()
        }
    }
}
