
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
                        .frame(height: 150)
                    
                    // Title ( Title / Guest )
                    TitleTurnCardFeedView(turn: turn)
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
            .padding(.horizontal, 12)
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
