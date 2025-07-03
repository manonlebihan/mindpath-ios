//
//  UserSession.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import Foundation

class UserSession: ObservableObject {
    @Published var token: String? {
        didSet {
            if let token = token {
                UserDefaults.standard.set(token, forKey: "authToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "authToken")
            }
        }
    }

    init() {
        self.token = UserDefaults.standard.string(forKey: "authToken")
    }

    func logout() {
        token = nil
    }
}
