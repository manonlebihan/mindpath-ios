//
//  AddEmotionView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct AddEmotionView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss

    @State private var note = ""
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    var onEmotionAdded: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Exprime ton émotion")
                .font(.title2)
                .bold()

            TextEditor(text: $note)
                .frame(height: 150)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: submitEmotion) {
                if isSubmitting {
                    ProgressView()
                } else {
                    Text("Envoyer")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(note.isEmpty || isSubmitting)

            Spacer()
        }
        .padding()
        .navigationTitle("Nouvelle émotion")
    }

    func submitEmotion() {
        isSubmitting = true
        errorMessage = nil

        APIService.shared.createEmotion(note: note, token: session.token ?? "") { result in
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    onEmotionAdded()
                    dismiss()
                case .failure:
                    errorMessage = "Erreur lors de l'envoi"
                }
            }
        }
    }
}
