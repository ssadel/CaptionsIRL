//
//  ImmersiveView.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/20/24.
//

import RealityKit
import SwiftUI

struct ImmersiveView: View {
    @Environment(Transcriber.self) var transcriber
    
    var body: some View {
        RealityView { content, attachments in
            let headAnchor = AnchorEntity(.head)
            content.add(headAnchor)
            
            if let view = attachments.entity(for: "CaptionsView") {
                view.position.z = -1
                view.position.y = -0.25
                headAnchor.addChild(view)
            }
        } attachments: {
            Attachment(id: "CaptionsView") {
                CaptionsView()
                    .environment(transcriber)
            }
        }
        .onAppear {
            try? transcriber.start()
        }
        .onDisappear {
            transcriber.stop()
        }
    }
}

#Preview {
    ImmersiveView()
}
