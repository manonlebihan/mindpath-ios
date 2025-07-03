//
//  EmotionRowView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct EmotionRowView: View {
    let emotion: Emotion

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(emotion.emotion.capitalized)
                .font(.headline)

            if let note = emotion.note {
                Text(note)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if let intensity = emotion.intensity {
                Text("Intensité : \(intensity)/5")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Text(formattedDate(emotion.created_at))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
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
