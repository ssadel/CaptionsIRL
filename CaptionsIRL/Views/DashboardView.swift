//
//  ContentView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import SwiftUI
import RealityKit

struct DashboardView: View {
    @State private var transcriber: Transcriber = .init()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Welcome to IRL Captions 👋")
                    .font(.extraLargeTitle.weight(.heavy))
                    .lineLimit(1)
                Text("Real-time captioning, regardless of the language.")
                    .font(.title.weight(.medium))
                NavigationLink {
                    TranscribingView()
                        .environment(transcriber)
                } label: {
                    Text("Begin")
                        .font(.headline.weight(.medium))
                }
                .padding(.top, 10)
            }
        }
        .frame(width: Sizes.windowSize.width, height: Sizes.windowSize.height)
        .glassBackgroundEffect()
    }
}

#Preview(windowStyle: .automatic) {
    DashboardView()
}
