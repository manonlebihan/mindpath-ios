//
//  RegisterView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Créer un compte")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Mot de passe", text: $password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            SecureField("Confirmer le mot de passe", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: register) {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Créer le compte")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .disabled(email.isEmpty || password.isEmpty || isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle("Inscription")
    }

    func register() {
        guard password == confirmPassword else {
            errorMessage = "Les mots de passe ne correspondent pas"
            return
        }

        isLoading = true
        APIService.shared.register(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let token):
                    session.token = token
                    dismiss()
                case .failure:
                    errorMessage = "Échec de l'inscription"
                }
            }
        }
    }
}
