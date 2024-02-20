//
//  CaptionsView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/20/24.
//

import SwiftUI

struct CaptionsView: View {
    @Environment(Transcriber.self) var transcriber
    
    @State private var currentTimestamp: TimeInterval = .zero
    @State private var alreadyDisplayedText: String = ""
    
    private var displayText: String {
        let segments = transcriber.segments
            //.filter { currentTimestamp + 5 > $0.timestamp }
            // .suffix(6)
        let string = segments
            .map { $0.substring }
            .joined(separator: " ")
        return string
    }
    
    var body: some View {
        
        Text(displayText)
            .font(.extraLargeTitle.weight(.black))
            .frame(maxWidth: 1000, alignment: .leading)
            .truncationMode(.head)
            .lineLimit(1)
            .padding(10)
            .background(
                ZStack {
                    if !displayText.isEmpty {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black.opacity(0.3))
                    }
                }
            )
            .frame(width: 1000)
//            .onChange(of: transcriber.transcribedText) {
//                if let resetDate = resetDate, Date.now > resetDate {
//                    try? transcriber.setupNewTask()
//                    self.resetDate = nil
//                } else {
//                    self.resetDate = .now.addingTimeInterval(3)
//                }
//            }
        
    }
}

#Preview {
    let transcriber = Transcriber()
    try? transcriber.start()
    
    return CaptionsView()
        .environment(transcriber)
}
