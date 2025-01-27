//
//  LargeButton.swift
//  CFQ
//
//  Created by Calvignac Charles on 15/01/2025.
//

import SwiftUI

struct ButtonParticipate: View{
    var action: () -> Void
    var cornerRadius: CGFloat = 6

    var body: some View {
        Button(action: action, label: {
            HStack {
                Text("T'y vas ?")
                    .foregroundColor(.white)
                    .padding(.leading, 15)
                    .padding(.vertical, 10)
                    .font(.system(size: 15, weight: .bold))
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 15)                    
                    .padding(.vertical, 10)
                    .font(.system(size: 10, weight: .bold))
            }
        })
        .background(Color(hex: "B098E6"))
        .cornerRadius(10)
    }

}

#Preview {
    ButtonParticipate(action: {})
}
