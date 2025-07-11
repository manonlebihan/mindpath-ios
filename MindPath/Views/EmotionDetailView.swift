//
//  EmotionDetailView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion
    
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @State private var showConfirm = false
    @State private var isDeleting = false
    @State private var deleteError: String? = nil
    
    var onDelete: (() -> Void)?


    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(emotion.emotion.capitalized)
                .font(.largeTitle)
                .bold()

            if let intensity = emotion.intensity {
                Text("Intensité : \(intensity)/5")
                    .font(.headline)
            }

            Text("Date : \(formattedDate(emotion.created_at))")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()

            if let note = emotion.note, !note.isEmpty {
                Text(note)
                    .font(.body)
            } else {
                Text("Pas de note.")
                    .italic()
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            if deleteError != nil {
                Text(deleteError!)
                    .foregroundColor(.red)
            }

            Button(role: .destructive) {
                showConfirm = true
            } label: {
                if isDeleting {
                    ProgressView()
                } else {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .alert("Confirmer la suppression", isPresented: $showConfirm) {
                Button("Supprimer", role: .destructive, action: delete)
                Button("Annuler", role: .cancel) { }
            }
        }
        .padding()
        .navigationTitle("Détail")
    }

    func formattedDate(_ iso: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: iso) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return iso
    }
    
    func delete() {
        isDeleting = true
        deleteError = nil

        APIService.shared.deleteEmotion(id: emotion.id, token: session.token ?? "") { result in
            DispatchQueue.main.async {
                isDeleting = false
                switch result {
                case .success:
                    onDelete?()
                    dismiss()
                case .failure:
                    deleteError = "Erreur lors de la suppression"
                }
            }
        }
    }
}
