//
//  DescriptionTurnCard.swift
//  CFQ
//
//  Created by Calvignac Charles on 24/01/2025.
//

import SwiftUI

struct DescriptionTurnCard: View {
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
        Text("Diner entre girls <3 Ramenez juste à boire!")
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .lineLimit(3)
    }
}
