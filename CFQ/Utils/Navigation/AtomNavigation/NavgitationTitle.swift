//
//  NavgitationTitle.swift
//  CFQ
//
//  Created by Calvignac Charles on 15/06/2025.
//

import SwiftUI

struct NavgitationTitle: View {
    var title: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .tokenFont(.Title_Gigalypse_24)
                .textCase(.uppercase)
        }
    }
}
