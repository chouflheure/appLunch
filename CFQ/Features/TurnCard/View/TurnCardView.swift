
import SwiftUI

struct TurnCardView: View {
    
    @Binding var isShow: Bool

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"]
    )
    
    @StateObject var viewModel = TurnCardViewModel()
    
    var body : some View {
        DraggableView(isPresented: $isShow) {
            SafeAreaContainer {
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation {
                                isShow = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Text("TURN")
                            .tokenFont(.Title_Gigalypse_24)
                        
                        Spacer()

                        Button(action: {
                            viewModel.showDetailTurnCard = true
                        }) {
                            Image(.iconEdit)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 24)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 25)
                    .zIndex(100)
                    
                    ZStack {
                        GradientCardView()
                        
                        VStack {
                            // Header
                            HeaderCardView(viewModel: viewModel, isPreviewCard: true)
                                .padding(.bottom, 15)
                                .frame(height: 100)
                            
                            // Title
                            TitleTurnCardView(viewModel: viewModel)
                                .padding(.horizontal, 16)
                            
                            // Informations
                            MainInformationsView(viewModel: viewModel)
                                .padding(.horizontal, 16)
                            
                            // Description
                            DescriptionTurnCard(viewModel: viewModel, isPreviewCard: true)
                                .padding(.horizontal, 16)
                            
                            Spacer()
                        }
                        .cornerRadius(20)
                        .frame(height: 500)
                        .padding(.horizontal, 12)
                        
                    }
                    .padding(.bottom, 30)
                    .zIndex(1)
                    
                    HStack(spacing: 30) {
                        Button(action: {}, label: {
                            HStack {
                                Image(.iconTrash)
                                    .foregroundColor(.white)
                                    .padding(.leading, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 10, weight: .bold))
                                Text("Supprimer")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 15, weight: .bold))
                            }
                        })
                        .frame(width: 150)
                        .background(.clear)
                        .cornerRadius(10)
                        .overlay() {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.white)
                                .background(.clear)
                        }
                        
                        Button(action: {}, label: {
                            HStack {
                                Image(.iconSend)
                                    .foregroundColor(.white)
                                    .padding(.leading, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 10, weight: .bold))

                                Text("Publier")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 15, weight: .bold))
                            }
                        })
                        .frame(width: 150)
                        .background(Color(hex: "B098E6"))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showDetailTurnCard) {
            TurnCardDetailsView(viewModel: viewModel)
        }
    }
}

#Preview {
    TurnCardView(isShow: .constant(true))
}





struct TurnCardViewAnimation: View {
    @StateObject var viewModel = TurnCardViewModel()
    var isShow: Bool
    var select: (Bool) -> Void
    @State private var dragOffset: CGFloat = 0

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"]
    )

    var body : some View {
        
        ZStack {
            GradientCardView()

            VStack {
                // Header
                HeaderCardView(viewModel: viewModel, isPreviewCard: true)
                    .padding(.bottom, 15)
                    .frame(height: 100)

                // Title
                TitleTurnCardView(viewModel: viewModel)
                    .padding(.horizontal, 16)

                // Informations
                MainInformationsView(viewModel: viewModel)
                    .padding(.horizontal, 16)

                // Description
                DescriptionTurnCard(viewModel: viewModel, isPreviewCard: true)
                    .padding(.horizontal, 16)

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
                    TurnCardViewAnimation(isShow: selectedCradId == cards[card].id,
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
