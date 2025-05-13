
import SwiftUI

struct TurnCardFeedView: View {
    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }
    
    var body: some View {
        VStack {
            ZStack {
                GradientCardView()

                VStack {
                    // Header ( Date / Picture / TURN )
                    HeaderCardNotEditableView(turn: turn)
                        .padding(.bottom, 15)
                        .frame(height: 100)
                    
                    // Title ( Title / Guest )
                    TitleTurnCardFeedView(turn: turn)
                        .padding(.horizontal, 16)
                    
                    // Informations ( Mood / Date / Loc )
                    MainInformationsPreviewFeedView(turn: turn)
                        .padding(.horizontal, 16)
                    
                    // Description ( Bio event )
                    DescriptionTurnCardFeedPreviewView(turn: turn)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .cornerRadius(20)
                .frame(height: 500)
                .padding(.horizontal, 12)
                
            }
            .zIndex(1)
        }

        .onTapGesture {
            print("@@@ tap card")
        }
            /*
        .fullScreenCover(isPresented: $viewModel.showDetailTurnCard) {
            TurnCardDetailsView(viewModel: viewModel)
        }
             */
    }
}
