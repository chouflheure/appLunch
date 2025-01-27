//
//  Description.swift
//  CFQ
//
//  Created by Calvignac Charles on 23/01/2025.
//

import SwiftUI

struct DescriptionCardTurned: View {
    var body: some View {
        Text("Diner entre girls <3 Ramenez juste à boire !")
            .foregroundColor(.white)
            .padding(.bottom, 20)
    }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        DescriptionCardTurned()
    }
}
