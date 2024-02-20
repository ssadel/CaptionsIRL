//
//  ContentView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import SwiftUI
import RealityKit

struct DashboardView: View {
    @Environment(Transcriber.self) var transcriber
    @AppStorage("sessionCount") var sessionCount: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
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
        .onAppear {
            sessionCount += 1
            if sessionCount == 2 || sessionCount == 10 {
                ReviewHelper.requestReview()
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    DashboardView()
}
