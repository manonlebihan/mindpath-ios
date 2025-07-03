//
//  MindPathApp.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

@main
struct MindPathApp: App {
    @StateObject var session = UserSession()

    var body: some Scene {
        WindowGroup {
            if session.token == nil {
                LoginView()
                    .environmentObject(session)
            } else {
                EmotionListView()
                    .environmentObject(session)
            }
        }
    }
}
