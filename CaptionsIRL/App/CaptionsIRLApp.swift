//
//  CaptionsIRLApp.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import SwiftUI

@main
struct CaptionsIRLApp: App {
    @State private var transcriber: Transcriber = .init()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(transcriber)
        }
        .windowResizability(.contentSize)
    }
}
