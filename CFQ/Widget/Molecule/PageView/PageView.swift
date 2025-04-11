
import SwiftUI

struct PageView: View {
    @State private var selectedIndex = 0
    var pageViewType: PageViewType

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<pageViewType.titles.count, id: \.self) { index in
                    VStack {
                        Text(pageViewType.title(at: index))
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
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(2)
                CollectionViewParticipant(viewModel: TurnCardViewModel())
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Mode Page sans dots
        }
    }
}
