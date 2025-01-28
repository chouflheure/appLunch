
import SwiftUI

struct TrunCardCreatedView: View {
    @StateObject var viewModel = TurnCardViewModel()

    var body : some View {
        ZStack {
            GradientCardView()
            
            VStack {
                // Header
                HeaderCardView(viewModel: viewModel)
                    .padding(.bottom, 15)
                
                // Title
                TitleTurnCardView(viewModel: viewModel)
                    .padding(.horizontal, 16)
                
                // Informations
                MainInformationsView(viewModel: viewModel)
                    .padding(.horizontal, 16)
                
                // Description
                DescriptionTurnCard(viewModel: viewModel)
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            .cornerRadius(20)
            .frame(height: 500)
        }
    }
}


#Preview {
    TrunCardCreatedView()
}
