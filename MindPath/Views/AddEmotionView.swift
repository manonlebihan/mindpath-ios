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
    @State private var selectedValence: String? = nil
    @State private var selectedEmotion = ""

    let emotionsParValence: [String: [String]] = [
        "plaisant": [
            "Amusement", "Apaisement", "Bonheur", "Calme", "Confiance",
            "Courage", "Excitation", "Fierté", "Gratitude", "Joie",
            "Optimisme", "Passion", "Satisfaction", "Soulagement"
        ],
        "neutre": [
            "Étonnement", "Indifférence", "Nostalgie", "Surprise"
        ],
        "déplaisant": [
            "Anxiété", "Colère", "Contrariété", "Culpabilité", "Déception",
            "Découragement", "Dégoût", "Désespoir", "Embarras", "Épuisement",
            "Frustration", "Honte", "Inquiétude", "Insécurité", "Irritation",
            "Jalousie", "Peur", "Solitude", "Stress", "Tristesse"
        ]
    ]

    var onEmotionAdded: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Exprime ton émotion")
                .font(.title2)
                .bold()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Comment te sens-tu globalement ?")
                    .font(.headline)

                HStack {
                    ForEach(["plaisant", "neutre", "déplaisant"], id: \.self) { valence in
                        Text(valence.capitalized)
                            .padding(10)
                            .background(selectedValence == valence ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedValence == valence ? .white : .primary)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedValence = valence
                                selectedEmotion = ""
                            }
                    }
                }

                if let valence = selectedValence {
                    Text("Quelle émotion correspond le mieux ?")
                        .font(.subheadline)
                        .padding(.top, 10)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(emotionsParValence[valence]!, id: \.self) { emotion in
                                Text(emotion.capitalized)
                                    .padding(8)
                                    .background(selectedEmotion == emotion ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedEmotion == emotion ? .white : .primary)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        selectedEmotion = emotion
                                    }
                            }
                        }
                    }
                }
            }


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
            .disabled(note.isEmpty || selectedEmotion.isEmpty || isSubmitting)

            Spacer()
        }
        .padding()
        .navigationTitle("Nouvelle émotion")
    }

    func submitEmotion() {
        print("Envoi émotion: note='\(note)', emotion='\(selectedEmotion)'")
        isSubmitting = true
        errorMessage = nil

        APIService.shared.createEmotion(note: note, emotion: selectedEmotion, token: session.token ?? "") { result in
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
