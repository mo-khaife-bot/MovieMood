//
//  ProfileView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    
    var body: some View {
        if let user = authVM.currentUser {
            List{
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4){
                            Text(user.fullName)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            
                            Text(user.email)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("Account") {
                    Button{
                        authVM.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
//                    Button{
////                        authVM.deleteAccount()
//                        print("Delete Account")
//                    } label: {
//                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
//                    }
                    
                }
            }

        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel()) // Provide an instance of AuthViewModel

    }
}
