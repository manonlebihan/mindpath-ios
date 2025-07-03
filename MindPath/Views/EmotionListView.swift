//
//  EmotionListView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct EmotionListView: View {
    @EnvironmentObject var session: UserSession
    @State private var emotions: [Emotion] = []

    var body: some View {
        NavigationView {
            List(emotions) { emotion in
                EmotionRowView(emotion: emotion)
            }
            .navigationTitle("Mes émotions")
            .toolbar {
                Button("Déconnexion") {
                    session.logout()
                }
            }
        }
        .onAppear {
            APIService.shared.fetchEmotions(token: session.token ?? "") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let emotions):
                        self.emotions = emotions
                    case .failure:
                        print("Erreur récupération émotions")
                    }
                }
            }
        }
    }
}
