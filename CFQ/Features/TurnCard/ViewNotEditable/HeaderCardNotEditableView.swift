
import SwiftUI

struct HeaderCardNotEditableView: View {
    
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .bottom) {

                    Image(.header)
                        .resizable()
                        .scaledToFit()
                        .contentShape(Rectangle())
                        .frame(height: 200)
                        .clipped()
                    
                    HStack(alignment: .center) {
                        DateLabel(
                            dayEventString: turn.date?.description ?? "",
                            monthEventString: turn.date?.description ?? ""
                        ).padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}
