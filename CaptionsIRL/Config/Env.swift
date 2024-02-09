//
//  Env.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import Foundation

struct Env {
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
