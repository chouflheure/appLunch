
import SwiftUI

struct TurnCardDetailsView: View {
    @StateObject var viewModel: TurnCardViewModel
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        ZStack {
            GradientCardDetailView()
            ScrollView {
                VStack {
                    // Header ( Date / Picture / TURN )
                    HeaderCardViewDetail(viewModel: viewModel)
                        .padding(.bottom, 15)
                        .frame(height: 200)

                    // Title ( Title / Guest )
                    TitleTurnCardDetailView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .zIndex(2)
                    
                    // Informations ( Mood / Date / Loc )
                    MainInformationsDetailView(viewModel: viewModel, coordinator: coordinator)
                        .padding(.horizontal, 16)
                    
                    // Description ( Bio event )
                    DescriptionTurnCardDetailView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 50)
                    
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .scrollDismissesKeyboard(.interactively)
        
    }
}
