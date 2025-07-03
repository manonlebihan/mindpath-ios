//
//  APIServices.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import Foundation

class APIService {
    static let shared = APIService()
    let baseURL = "http://localhost:8000"  // Change avec ngrok si besoin

    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "username=\(email)&password=\(password)"
        request.httpBody = body.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let result = try? JSONDecoder().decode([String: String].self, from: data),
                  let token = result["access_token"] else {
                completion(.failure(NSError(domain: "", code: 0)))
                return
            }

            completion(.success(token))
        }.resume()
    }

    func fetchEmotions(token: String, completion: @escaping (Result<[Emotion], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/emotions") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let emotions = try? JSONDecoder().decode([Emotion].self, from: data) else {
                completion(.failure(NSError(domain: "", code: 0)))
                return
            }

            completion(.success(emotions))
        }.resume()
    }
}
