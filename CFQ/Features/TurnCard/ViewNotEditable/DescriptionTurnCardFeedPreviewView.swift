//
//  Untitled 3.swift
//  CFQ
//
//  Created by Calvignac Charles on 07/05/2025.
//

import SwiftUI

struct DescriptionTurnCardFeedPreviewView: View {
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {

        HStack {
            Text(turn.description)
                .tokenFont(.Body_Inter_Medium_14)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
