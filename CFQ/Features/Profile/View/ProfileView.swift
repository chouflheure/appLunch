
import SwiftUI

struct ProfileView2: View {
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {},
                    label: {
                        Image(.iconArrow)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    })
                Spacer()
                Button(
                    action: {},
                    label: {
                        Image(.iconParametres)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    })
            }.padding(.bottom, 32)
            
            HStack {
                SwitchStatusUserProfile()
                    .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Pseudo")
                            .tokenFont(.Body_Inter_Medium_16)
                        Text(" ~ " + "Nil B.")
                            .tokenFont(.Placeholder_Inter_Regular_16)
                    }
                    HStack(alignment: .center) {
                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text("Localisation")
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                }
                Spacer()
                Button(
                    action: {},
                    label: {
                        Image(.iconUser)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.white)
                    })
            }
            .padding(.bottom, 16)
            
            PageViewEvent()

        }
        .padding(.top, 50)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        ProfileView2()
    }
}


struct PageViewEvent: View {
    @State private var selectedIndex = 0
    let titles = ["TURNs", "CALENDRIER"]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            // PageView avec TabView
            TabView(selection: $selectedIndex) {
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(0)
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Mode Page sans dots
        }
    }
}


struct ProfileView: View {
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
