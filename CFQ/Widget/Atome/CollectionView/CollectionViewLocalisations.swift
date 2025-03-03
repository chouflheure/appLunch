import SwiftUI

struct CollectionViewLocalisations: View {
    var items = LocalisationType.allCases

    @State var selectedItems: Set<String>

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items, id: \.self) { item in
                    ItemViewLocalisation(
                        city: item.title,
                        isSelected: selectedItems.contains(item.title)
                    )
                    .onTapGesture {
                        toggleSelection(of: item)
                    }
                }
            }
            .padding()
        }
    }

    func toggleSelection(of item: LocalisationType) {
        if selectedItems.contains(item.title) {
            selectedItems.remove(item.title)
        } else {
            selectedItems.insert(item.title)
        }
    }
}

#Preview {
    var selectedItems: Set<String> = []
    ZStack {
        NeonBackgroundImage()
        CollectionViewLocalisations(selectedItems: selectedItems)
    }
}
