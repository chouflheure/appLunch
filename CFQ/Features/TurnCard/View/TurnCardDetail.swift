
import SwiftUI

struct TurnCardDetailsView: View {
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
        ZStack {
            GradientCardDetailView()
            
            ScrollView {
                VStack {
                    // Header
                    HeaderCardView(viewModel: viewModel, isPreviewCard: false)
                        .padding(.bottom, 15)
                        .frame(height: 200)
                    
                    // Title
                    TitleTurnCardView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                    
                    // Informations
                    MainInformationsView(viewModel: viewModel)
                        .padding(.horizontal, 16)
                    
                    // Description
                    DescriptionTurnCard(viewModel: viewModel, isPreviewCard: false)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
        }.ignoresSafeArea()
    }
}

#Preview {
    TurnCardDetailsView(viewModel: TurnCardViewModel())
}
