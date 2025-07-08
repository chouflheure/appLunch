
import SwiftUI

struct PlaceItem: Hashable, Identifiable {
    let id = UUID()
    let value: String
    
    init(locationType: PlaceType) {
        self.value = locationType.rawValue
    }
    
    init(customValue: String) {
        self.value = customValue
    }
}

struct LocationItem: Hashable, Identifiable {
    let id = UUID()
    let value: String
    
    init(locationType: LocalisationType) {
        self.value = locationType.rawValue
    }

    init(customValue: String) {
        self.value = customValue
    }
}

struct CollectionViewLocalisations: View {
    @Binding var selectedItem: String
    @State var searchText: String = ""
    @State private var items: Set<LocationItem> = []
    @FocusState private var isSearchFocused: Bool

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 16) {
            
            SearchBarView(
                text: $searchText,
                placeholder: StringsToken.Sign.TitleWhichIsYourLocalisation,
                onRemoveText: {searchText = ""},
                onTapResearch: {}
            ).onSubmit {
                addCustomLocation()
            }

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(filteredItems)) { item in
                        ItemViewLocalisation(
                            city: item.value,
                            isSelected: selectedItem == item.value
                        )
                        .onTapGesture {
                            toggleSelection(of: item)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            initializeItems()
        }
    }
    
    // Filtrer les items en fonction de la recherche
    private var filteredItems: Set<LocationItem> {
        guard !searchText.isEmpty else { return items }
        
        let filtered = items.filter { item in
            item.value.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.isEmpty ? Set([LocationItem(customValue: searchText)]) : filtered
    }
    
    private func initializeItems() {
        if items.isEmpty {
            items = Set(LocalisationType.allCases.map { LocationItem(locationType: $0) })
        }
    }
    
    private func addCustomLocation() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Vérifier si l'élément existe déjà (case insensitive)
        if !items.contains(where: { $0.value.lowercased() == trimmedText.lowercased() }) {
            let customItem = LocationItem(customValue: trimmedText)
            items.insert(customItem)
        }
        
        // Sélectionner automatiquement le nouvel élément
        selectedItem = trimmedText
        searchText = ""
        isSearchFocused = false
        
        // Animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            // L'animation se fera automatiquement avec la mise à jour de selectedItem
        }
    }
    
    private func toggleSelection(of item: LocationItem) {
        items.insert(item)
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedItem != item.value {
                selectedItem = item.value
            } else {
                selectedItem = ""
            }
        }
    }
}
