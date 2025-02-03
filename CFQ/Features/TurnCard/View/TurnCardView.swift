
import SwiftUI

struct TurnCardView: View {
    @StateObject var viewModel = TurnCardViewModel()
    var isShow: Bool
    var select: (Bool) -> Void
    @State private var dragOffset: CGFloat = 0

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
                    // .padding(.horizontal, 16)

                Spacer()
            }
            .cornerRadius(20)
            .frame(height: 500)
            .padding(.horizontal, 12)
        }
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if isShow {
                        dragOffset = gesture.translation.height
                    }
                }
                .onEnded { gesture in
                    if isShow && dragOffset > 50 {
                        withAnimation(.spring()) {
                            dragOffset = 0
                            select(false)
                            viewModel.isEditing = false
                        }
                    } else {
                        withAnimation(.spring()) {
                            dragOffset = 0
                        }
                    }
                }
            )
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                print("@@@ selected")
                select(!isShow)
                viewModel.isEditing = !isShow
            }
        }
    }
}

#Preview {
    TurnCardView(
        isShow: true,
        select: {selected in print("Card selected \(selected)")}
    )
}


struct Screen: View {
    @State var selectedCradId: UUID? = nil
    var cards: [TurnCard] = [
        TurnCard(title: "test1"),
        TurnCard(title: "test2"),
        TurnCard(title: "test3")
    ]

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(cards.indices, id: \.self) { card in
                    TurnCardView(isShow: selectedCradId == cards[card].id,
                                 select: {self.selectedCradId = $0 ? cards[card].id : nil}
                    )
                    .offset(y: calculateOffSetForCard(at: card))
                }
            }.frame(height: 10)
        }
    }

    func calculateOffSetForCard(at index: Int) -> CGFloat {
        let selectedCardIndex = cards.firstIndex(where: {$0.id == selectedCradId})
        switch selectedCardIndex {
        case .none:
            return CGFloat(index * 80)
        case .some(let selectedIndex) where selectedIndex == index:
            let screenHeight = UIScreen.main.bounds.height
            let cardHeight: CGFloat = 500
            let centerOffset = (screenHeight - (cardHeight - CGFloat(index * 80))) / 2
            return -screenHeight/2
        case .some:
            return 300

        }
    }
}

#Preview {
    Screen()
}
