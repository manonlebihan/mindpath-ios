//
//  Emotion.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import Foundation

struct Emotion: Identifiable, Codable {
    let id: Int
    let emotion: String
    let note: String?
    let intensity: Int?
    let created_at: String
}
