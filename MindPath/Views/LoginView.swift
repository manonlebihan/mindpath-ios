//
//  LoginView.swift
//  MindPath
//
//  Created by Manon Le Bihan on 03/07/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Connexion")
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

                if let error = error {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button("Se connecter") {
                    APIService.shared.login(email: email, password: password) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let token):
                                session.token = token
                            case .failure:
                                error = "Échec de la connexion"
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                NavigationLink("Créer un compte", destination: RegisterView())
                    .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Connexion")
        }
    }
}
