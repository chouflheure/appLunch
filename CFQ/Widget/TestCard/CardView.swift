
import SwiftUI

struct CardView: View {
    var show: Bool
    var card: Card
    var select: (Bool) -> Void
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(card.cardName)
                +
                Text(" Card")
                Spacer()
                Image(systemName: card.logo)
            }
            Spacer()
            Text(card.num)
            +
            Text(" .00")
        }
        .padding()
        .frame(height: 200)
        .background((card.color), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .offset(y: dragOffset) // 🔹 Appliquer l'offset
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if show {
                                dragOffset = gesture.translation.height
                            }
                        }
                        .onEnded { gesture in
                            if show && dragOffset > 50 { // 🔹 Seuil pour fermer la carte
                                withAnimation(.spring()) {
                                    dragOffset = 0
                                    select(false)  // 🔹 Désélectionne la carte
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
                select(!show)
            }
        }
        
        
    }
}

#Preview {
    CardView(
        show: false, card: card.first!, select: {selected in print("Card selected \(selected)")}
    )
}


import Foundation


struct Card: Identifiable {
    var id = UUID()
    var color: Color
    var cardName: String
    var logo: String
    var num: String
}

var card: [Card] = [
    Card(color: .red, cardName: "Shop", logo: "cart", num: "65, 973"),
    Card(color: .yellow, cardName: "Play", logo: "gamecontroller", num: "22, 12"),
    Card(color: .blue, cardName: "Medic", logo: "bandage.fill", num: "10, 73"),
    Card(color: .red, cardName: "Shop", logo: "cart", num: "65, 973"),
    Card(color: .purple, cardName: "Shop", logo: "cart", num: "65, 973"),
    Card(color: .pink, cardName: "Shop", logo: "cart", num: "65, 973"),
    Card(color: .green, cardName: "Shop", logo: "cart", num: "65, 973"),
]

struct Test: View {
    @State var cards: [Card] = card
    @State var selectedCradId: UUID? = nil
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(cards.indices, id: \.self) { card in
                    CardView(show: selectedCradId == cards[card].id,
                             card: cards[card],
                             select: {self.selectedCradId = $0 ? cards[card].id : nil})
                    .offset(y: calculateOffSetForCard(at: card))
                }
            }
        }
    }

    func calculateOffSetForCard(at index: Int) -> CGFloat {
        let selectedCardIndex = cards.firstIndex(where: {$0.id == selectedCradId})
        switch selectedCardIndex {
        case .none:
            return CGFloat(index*10)
        case .some(let selectedIndex) where selectedIndex == index:
            return -300
        case .some(let selectedIndex):
            if selectedIndex < index {
                return CGFloat(index * 80)
            } else {
                return CGFloat((index + 1) * 83)
            }
        }
    }
}

#Preview {
    Test()
}
