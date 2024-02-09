//
//  TranscribingView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import SwiftUI

struct TranscribingView: View {
    enum ScrollPosition {
        case top
        case middle
        case bottom
    }
    
    @Environment(Transcriber.self) var transcriber
    @Environment(\.dismiss) var dismiss
    
    @State private var scrollPosition: ScrollPosition?
    @State private var showBottomToast: Bool = false
    
    var text: String {
        transcriber.transribedText
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            LazyVStack {
                Text("Say something to begin transcribing ✏️")
                    .font(.headline.weight(.regular).italic())
                    .padding(.bottom)
                    .id(ScrollPosition.top)
                
                Text(text)
                    .font(.largeFont)
                    .shadow(radius: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .id(ScrollPosition.middle)
                
                Text("")
                    .id(ScrollPosition.bottom)
                    .padding(.bottom)
            }
            .scrollTargetLayout()
            .frame(width: Sizes.windowSize.width * 0.9)
        }
        .defaultScrollAnchor(.bottom)
        .scrollPosition(id: $scrollPosition, anchor: .bottom)
        .overlay(bottomToast, alignment: .bottom)
        .onChange(of: scrollPosition) { oldValue, newValue in
            guard newValue != ScrollPosition.bottom else {
                showBottomToast = false
                return
            }
            showBottomToast = true
        }
        .animation(.interactiveSpring, value: showBottomToast)
        .onAppear {
            guard !Env.isPreview else { return }
            
            do {
                try transcriber.start()
            } catch {
                dismiss()
            }
        }
        .onDisappear {
            guard !Env.isPreview else { return }
            
            transcriber.stop()
        }
        
    }
    
    private var bottomToast: some View {
        ZStack {
            if showBottomToast {
                Button {
                    withAnimation {
                        scrollPosition = .bottom
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.largeTitle)
                        .shadow(radius: 4)
                }
                .contentShape(Circle())
                .padding(.bottom)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    return NavigationStack {
        Text("yo")
            .navigationDestination(isPresented: .constant(true)) {
                TranscribingView()
                    .environment(Transcriber())
            }
    }
}
