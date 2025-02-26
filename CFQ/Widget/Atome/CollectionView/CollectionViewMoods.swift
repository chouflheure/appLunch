import SwiftUI

struct CollectionViewMoods: View {
    @State private var items = MoodType.allCases
    @StateObject var viewModel: TurnCardViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items, id: \.self) { item in
                ItemViewMood(mood: item, isSelected: viewModel.moods.contains(item))
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


struct CollectionViewExample_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            CollectionViewMoods(viewModel: TurnCardViewModel())
        }
    }
}
