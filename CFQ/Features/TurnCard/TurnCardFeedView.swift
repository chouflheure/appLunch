
import SwiftUI

struct TurnCardFeedView: View {
    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    @State var showDetail: Bool = false

    init(turn: Turn, coordinator: Coordinator) {
        self.turn = turn
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack {
            ZStack {
                GradientCardView()

                VStack {
                    // Header ( Date / Picture / TURN )
                    HeaderCardNotEditableView(turn: turn)
                        .padding(.bottom, 15)
                        .frame(height: 150)
                    
                    // Title ( Title / Guest )
                    TitleTurnCardFeedView(turn: turn, coordinator: coordinator)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)

                    // Informations ( Mood / Date / Loc )
                    MainInformationsPreviewFeedView(turn: turn)
                        .padding(.horizontal, 16)
                    
                    // Description ( Bio event )
                    DescriptionTurnCardFeedPreviewView(turn: turn)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 0.2)
            }
            .frame(height: 550)
            .cornerRadius(20)
            .zIndex(1)
        }
        .onTapGesture {
            coordinator.turnSelected = turn
            withAnimation {
                coordinator.showTurnFeedDetail = true
            }
        }
    }
}
