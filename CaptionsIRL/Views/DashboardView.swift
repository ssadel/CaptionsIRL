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
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var isSpaceOpen: Bool = false
    @AppStorage("sessionCount") var sessionCount: Int = 0
    
    private var frame: CGSize {
        let width = isSpaceOpen ? Sizes.windowSize.width / 2 : Sizes.windowSize.width
        let height = isSpaceOpen ? Sizes.windowSize.height / 2 : Sizes.windowSize.height
        return .init(width: width, height: height)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isSpaceOpen {
                    spaceOpenView
                } else {
                    defaultView
                }
            }
            .animation(.bouncy, value: isSpaceOpen)
        }
        .frame(width: frame.width, height: frame.height)
        .onAppear {
            sessionCount += 1
            if sessionCount == 2 || sessionCount == 10 {
                ReviewHelper.requestReview()
            }
        }
    }
    
    private var defaultView: some View {
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
            
            HStack {
                NavigationLink {
                    TranscribingView()
                        .environment(transcriber)
                } label: {
                    Text("Enter Transcription Mode")
                        .font(.headline.weight(.medium))
                }
                
                Button {
                    Task {
                        await openImmersiveSpace(id: "Immersive")
                        isSpaceOpen = true
                    }
                } label: {
                    Text("Enter CaptionsIRL Mode")
                }
            }
            .padding(.top, 10)
        }
    }
    
    private var spaceOpenView: some View {
        Button {
            Task {
                await dismissImmersiveSpace()
                isSpaceOpen = false
            }
        } label: {
            Text("Go Back")
                .font(.extraLargeTitle.weight(.heavy))
        }
        .padding(40)
    }
}

#Preview(windowStyle: .automatic) {
    DashboardView()
}
