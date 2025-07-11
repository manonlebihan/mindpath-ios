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
            /*List(emotions) { emotion in
                NavigationLink(destination: EmotionDetailView(
                    emotion: emotion,
                    onDelete: {
                        reloadEmotions()
                    }
                )) {
                    EmotionRowView(emotion: emotion)
                }
            }*/
            List {
                ForEach(emotions) { emotion in
                    NavigationLink(destination: EmotionDetailView(
                        emotion: emotion,
                        onDelete: { reloadEmotions() }
                    )) {
                        EmotionRowView(emotion: emotion)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            deleteEmotion(emotion)
                        } label: {
                            Label("Supprimer", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Mes émotions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Déconnexion") {
                        session.logout()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEmotionView(onEmotionAdded: {
                        reloadEmotions()
                    })) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear(perform: reloadEmotions)
    }
    
    func reloadEmotions() {
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
    
    func deleteEmotion(_ emotion: Emotion) {
        APIService.shared.deleteEmotion(id: emotion.id, token: session.token ?? "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    reloadEmotions()
                case .failure:
                    print("Erreur lors de la suppression de l’émotion")
                }
            }
        }
    }
}
