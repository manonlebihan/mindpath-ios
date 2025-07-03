//
//  EmotionDetailView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct EmotionDetailView: View {
    let emotion: Emotion

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
}
