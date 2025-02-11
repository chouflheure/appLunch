//
//  TextFieldThinIndicator.swift
//  CFQ
//
//  Created by Calvignac Charles on 24/01/2025.
//

import SwiftUI

/*
struct TextFieldThinIndicator: View {
    @Binding var text: String
    let keyBoardType: UIKeyboardType
    let placeHolder: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeHolder).foregroundColor(.gray)
                    .textCase(.uppercase)
        }.onChange(of: text) { newValue in
            text = newValue.uppercased() // Convertit le texte en majuscules
        }
            .foregroundColor(.white)
            .font(.title)
            .background(.clear)
            .keyboardType(keyBoardType)
            .bold()
            
    }
    
}

private struct ParentView: View {
    @State private var currentIndex = ""

    var body: some View {
        VStack {
            TextFieldThinIndicator(
                text: $currentIndex,
                keyBoardType: .default,
                placeHolder: "test"
            )
        }
    }
}

#Preview {
    ParentView()
}

*/
