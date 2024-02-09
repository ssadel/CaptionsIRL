//
//  CaptionsIRLApp.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import SwiftUI

@main
struct CaptionsIRLApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
