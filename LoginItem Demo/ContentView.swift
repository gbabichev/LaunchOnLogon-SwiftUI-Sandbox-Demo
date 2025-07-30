//
//  ContentView.swift
//  LoginItem Demo
//
//  Created by George Babichev on 7/29/25.
//

import SwiftUI                  // Imports SwiftUI for building the user interface
import ServiceManagement        // Imports ServiceManagement for working with login items

struct ContentView: View {
    // Static constant for the helper app's bundle identifier
    //
    // SET YOUR HELPER BUNDLE ID HERE!!!
    private static let loginHelperIdentifier = "com.georgebabichev.LoginItem-Helper"
    // DID YOU SET THE HELPER BUNDLE ID???
    //
    
    // State variable to track if the helper is currently enabled as a login item
    // This block checks the current status when the view initializes
    @State private var isChecked: Bool = {
        let loginService = SMAppService.loginItem(identifier: loginHelperIdentifier)
        return loginService.status == .enabled   // True if login item is currently enabled
    }()
    
    var body: some View {
        // The main UI: a checkbox toggle labeled "Launch at Login"
        Toggle("Launch at Login", isOn: $isChecked)
            .toggleStyle(.checkbox)             // Makes the toggle look like a checkbox (macOS style)
            .padding()                          // Adds padding around the checkbox
            .onChange(of: isChecked) {          // Runs when the checkbox value changes
                toggleLaunchAtLogin(isChecked)  // Calls function to enable/disable the login item
            }
    }
    
    // Handles enabling or disabling the login helper at login
    private func toggleLaunchAtLogin(_ enabled: Bool) {
        // Create a reference to the login item service using the static identifier
        let loginService = SMAppService.loginItem(identifier: Self.loginHelperIdentifier)
        do {
            if enabled {
                // If enabled, try to register the login helper so it launches at login
                try loginService.register()
            } else {
                // If disabled, try to unregister it
                try loginService.unregister()
            }
        } catch {
            // If anything fails, show a user-facing alert dialog with error info
            showErrorAlert(message: "Failed to update Login Item.", info: error.localizedDescription)
        }
    }

    // Utility to show an error alert dialog to the user
    private func showErrorAlert(message: String, info: String? = nil) {
        let alert = NSAlert()                  // Create a new alert
        alert.messageText = message            // Set the main alert message
        if let info = info {                   // Optionally set additional error details
            alert.informativeText = info
        }
        alert.alertStyle = .warning            // Set alert style (yellow exclamation)
        alert.runModal()                       // Display the alert as a modal dialog
    }
}
