//
//  RegistrationView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authViewModel : AuthViewModel
    
    
    var body: some View {
        VStack{
            Image(systemName: "globe")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .padding(.vertical, 32)
            
            VStack(spacing: 24){
                Inputview(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(.none)
                
                Inputview(text: $fullName, title: "Full Name", placeholder: "Enter your name")

                
                Inputview(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                
                Inputview(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button{
                Task{
                    try await authViewModel.createUser(withEmail: email, password: password,  fullname: fullName)
                }
            } label: {
                HStack{
                    Text("SIGN UP").fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 52, height: 48)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button{
                dismiss()
            } label: {
                HStack{
                    Text("Already have an account")
                    Text("Sign in").fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
            
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

