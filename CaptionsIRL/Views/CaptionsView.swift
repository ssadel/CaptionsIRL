//
//  CaptionsView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/20/24.
//

import SwiftUI
import Speech

struct CaptionsView: View {
    enum CursorType: Int {
        case characters = -1
        case time = 0
    }
    
    @Environment(Transcriber.self) var transcriber
    
    @State private var lastCaptionDate: Date?
    @State private var segmentCursor: (segment: SFTranscriptionSegment?, type: CursorType) = (nil, .characters)
    
    private var displayText: String {
        var segments = transcriber.segments
        if let segment = segmentCursor.segment, let index = transcriber.segments.firstIndex(of: segment) {
            segments.removeSubrange(0...(index-segmentCursor.type.rawValue))
        }
        let string = segments
            .map { $0.substring }
            .joined(separator: " ")
        return string
    }
    
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Text(displayText)
            .font(.extraLargeTitle.weight(.black))
            .padding(10)
            .background(
                ZStack {
                    if !displayText.isEmpty {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.4))
                    }
                }
            )
            .frame(width: 1100, alignment: .leading)
            .onChange(of: displayText) {
                lastCaptionDate = .now
                if displayText.count > 80 {
                    segmentCursor = (transcriber.segments.last, .characters)
                }
            }
            .onReceive(timer) { _ in
                guard let lastCaptionDate = lastCaptionDate else { return }
                if lastCaptionDate.addingTimeInterval(3) < .now {
                    segmentCursor = (transcriber.segments.last, .time)
                    self.lastCaptionDate = nil
                }
            }
        
    }
}

#Preview {
    let transcriber = Transcriber()
    // try? transcriber.start()
    
    return CaptionsView()
        .environment(transcriber)
}
