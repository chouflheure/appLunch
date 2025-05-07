
import SwiftUI

struct HeaderCardNotEditableView: View {
    
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    Image(.background1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 100)
                        .clipped()
                }
                
                DateLabel(
                    dayEventString: "12",
                    monthEventString: "Juin"
                )
                .padding(.top, 20)
                .padding(.leading, 16)
            }
            .frame(height: 100)
            .contentShape(Rectangle()) // Définit explicitement la forme interactive
        }
        .frame(maxWidth: .infinity)
    }
}
