
import SwiftUI

struct DescriptionTurnCard: View {
    @StateObject var viewModel: TurnCardViewModel

    var body: some View {
        Text("Diner entre girls <3 Ramenez juste à boire!")
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .padding(.top, 10)
            .lineLimit(3)
    }
}

#Preview {
    ZStack {
        Color.blue.edgesIgnoringSafeArea(.all)
        DescriptionTurnCard(viewModel: TurnCardViewModel())
    }
}
