//
//  SerialTemplateApp.swift
//  SerialTemplate
//
//  Created by Peter Rogers on 20/10/2025.
//

import SwiftUI

@main
struct SerialTemplateApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var serial = SerialManager()
    // For manual testing of mock mode, you can toggle:
    // @State private var serial = MockSerialManager()

    var body: some Scene {
        WindowGroup {
            ContentView(serial: serial)
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                print("🛑 App moving to background — closing serial.")
                serial.disconnect()
            }
        }
    }
}
