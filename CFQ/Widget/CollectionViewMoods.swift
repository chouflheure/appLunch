import SwiftUI

struct CollectionViewMoods: View {
    @State private var items = MoodType.allCases
    @State private var selectedItems: Set<MoodType> = []
    @StateObject var viewModel: TurnCardViewModel

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items, id: \.self) { item in
                ItemView(mood: item, isSelected: viewModel.moods.contains(item))
                    .onTapGesture {
                        toggleSelection(of: item)
                    }
            }
        }
        .padding()
    }

    private func toggleSelection(of item: MoodType) {
        if viewModel.moods.contains(item) {
            viewModel.moods.remove(item)
        } else {
            viewModel.moods.insert(item)
        }
    }
}

struct ItemView: View {
    let mood: MoodType
    let isSelected: Bool

    var body: some View {
        Mood().data(for: mood)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: isSelected ? 0.9 : 0)
                    .animation(.bouncy, value: isSelected)
                    .shadow(radius: isSelected ? 5 : 1)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            )
    }
}

struct CollectionViewExample_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CollectionViewMoods(viewModel: TurnCardViewModel())
        }
    }
}
