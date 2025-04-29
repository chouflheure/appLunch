import SwiftUI

struct CollectionViewLocalisations: View {
    var items = LocalisationType.allCases

    @Binding var selectedItem: String
    var scrollDisabled: Bool? = false

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
                        isSelected: selectedItem == item.title // selectedItems.contains(item.title)
                    )
                    .onTapGesture {
                        toggleSelection(of: item)
                    }
                }
            }
            .padding()
        }.scrollDisabled(scrollDisabled ?? false)
    }

    func toggleSelection(of item: LocalisationType) {
        if selectedItem != item.title {
            selectedItem = item.title
        }
    }
}
