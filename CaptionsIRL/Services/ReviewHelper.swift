//
//  ReviewHelper.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/12/24.
//

import Foundation
import StoreKit

struct ReviewHelper {
    static func requestReview() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}
