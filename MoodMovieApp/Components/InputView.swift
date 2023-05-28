//
//  InputView.swift
//  MoodMovieApp
//
//  Created by mohomed Ali on 28/05/2023.
//

import SwiftUI

struct Inputview: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var isSecureField = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if isSecureField{
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
        }
    }
}

struct Inputview_Previews: PreviewProvider {
    static var previews: some View {
        Inputview(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
    }
}

