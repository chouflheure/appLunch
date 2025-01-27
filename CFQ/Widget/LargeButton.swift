//
//  LargeButton.swift
//  CFQ
//
//  Created by Calvignac Charles on 15/01/2025.
//

import SwiftUI

struct FullButtonLogIn: View{
    var action: () -> Void
    var title: String
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.white, lineWidth: 0.5)
                )
                
        })
    }
}

struct PurpleButtonLogIn: View {
    var action: () -> Void
    var title: String
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            Text(title)
                .foregroundColor(.purple)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.clear)
        })
    }
}

#Preview {
    FullButtonLogIn(action: {}, title: "Connexion")
    PurpleButtonLogIn(action: {}, title: "Connexion")
}
