import SwiftUI

struct CollectionViewLocalisations: View {
    var items = LocalisationType.allCases
    var viewModel: SignUpPageViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items, id: \.self) { item in
                    ItemViewLocalisation(city: item.title, isSelected: viewModel.locations.contains(item.title))
                        .onTapGesture {
                            toggleSelection(of: item)
                        }
                }
            }
            .padding()
        }
    }

    private func toggleSelection(of item: LocalisationType) {
        if viewModel.locations.contains(item.title) {
            viewModel.locations.remove(item.title)
        } else {
            viewModel.locations.insert(item.title)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CollectionViewLocalisations(viewModel: SignUpPageViewModel(uidUser: ""))
    }
}
