//
//  Untitled 2.swift
//  CFQ
//
//  Created by Calvignac Charles on 07/05/2025.
//

import SwiftUI

struct MainInformationsPreviewFeedView: View {
    
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        MoodTemplateView()
                    }
                }
                .padding(.horizontal, 12)
                
                HStack {

                    Image(.iconDate)
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .padding(.leading, 12)
                    
                    Text("Date")
                        .tokenFont(.Body_Inter_Medium_16)

                    Text(" | ")
                        .foregroundColor(.white)

                    Text("Heure de début")
                        .tokenFont(.Body_Inter_Medium_16)
                }

                HStack(alignment: .top) {
                    
                    Image(systemName: "mappin")
                        .foregroundColor(.white)
                    
                    Text("Lieu")
                        .foregroundColor(.white)
                        
                    Text("|")
                        .foregroundColor(.white)
                    
                    Text("92240 Malakoff ")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 0.8)
            )
        }
}
