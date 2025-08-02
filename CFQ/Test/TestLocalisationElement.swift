
import SwiftUI
import MapKit
import SafariServices
import Combine

struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    var mapItem: MKMapItem
}

class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var results: [MKLocalSearchCompletion] = []

    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
    }

    func updateQueryFragment(_ fragment: String) {
        completer.queryFragment = fragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

struct SelectLocalisationView: View {
    @State private var searchTextPlace = ""
    @State private var searchTextLocation = ""
    @State var searchText: String = ""
    @State private var items: Set<PlaceItem> = []
    @State private var isFocusSelectorAdresse = false

    @FocusState private var isSearchFocused: Bool
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    
    @StateObject private var searchCompleter = SearchCompleter()
    @ObservedObject var viewModel: TurnCardViewModel
    @Binding var isPresented: Bool

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var showingSafariView = false
    @State private var selectedURL: URL?
    @State private var selectedLocation: IdentifiableMapItem?
    @State private var selectedResult: MKLocalSearchCompletion?

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(.iconEdit)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                    
                    Text("Le nom du lieu : ( optionnel ) ")
                        .tokenFont(.Label_Inter_Semibold_16)
                }
                .padding(.horizontal, 16)

                SearchBarView(
                    text: $searchText,
                    placeholder: "ex: Chez moi",
                    onRemoveText: {searchText = ""},
                    onTapResearch: {}
                )
                .onSubmit {
                    addCustomLocation()
                }

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(filteredItems)) { item in
                            ItemViewLocalisation(
                                city: item.value,
                                isSelected: searchTextPlace == item.value
                            )
                            .onTapGesture {
                                toggleSelection(of: item)
                            }
                        }
                    }
                    .padding()
                }
            }
            .opacity(isFocusSelectorAdresse ? 0 : 1)
            .frame(height: isFocusSelectorAdresse ? 10 : 200)
            .padding(.top, 30)

            VStack(alignment: .leading) {
                HStack {
                    Image(.iconLocation)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)

                    Text("L'adresse exacte : ")
                        .tokenFont(.Label_Inter_Semibold_16)
                }
                .padding(.horizontal, 16)

                SearchBarView(
                    text: $searchTextLocation,
                    placeholder: "ex: 1 rue de Clichy",
                    onRemoveText: {
                        searchTextLocation = ""
                        isFocusSelectorAdresse = false
                    },
                    onTapResearch: {
                        isFocusSelectorAdresse = false
                    }
                )
                .padding(.top, 15)
                .onChange(of: searchTextLocation) { newValue in
                    if searchTextLocation.isEmpty {
                        isFocusSelectorAdresse = false
                    } else {
                        isFocusSelectorAdresse = true
                    }

                    searchCompleter.updateQueryFragment(newValue)
                }
                
                ScrollView(showsIndicators: false) {
                    ForEach(searchCompleter.results, id: \.self) { result in
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                Text(result.title)
                                Spacer()
                            }.padding(.bottom, 5)
                            
                            HStack(spacing: 0) {
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(selectedResult == result ? .grayCard : .clear)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                viewModel.placeTitle = result.title
                                viewModel.placeAdresse = result.subtitle
                                searchForLocation(completion: result)
                                selectedResult = result
                                
                                if !searchTextPlace.isEmpty {
                                    viewModel.placeAdresse = viewModel.placeTitle + " • " + viewModel.placeAdresse
                                    viewModel.placeTitle = searchTextPlace
                                }
                                isFocusSelectorAdresse = false
                                isPresented = false
                            }
                        }
                        
                        Divider()
                            .background(.white)
                            .padding(.horizontal, 12)
                    }
                }
            }
                .padding(.top, 30)
            Button(action: {
                if !searchTextPlace.isEmpty {
                    viewModel.placeAdresse = viewModel.placeTitle + " • " + viewModel.placeAdresse
                    viewModel.placeTitle = searchTextPlace
                }
                isFocusSelectorAdresse = false
                isPresented = false
            }, label: {
                Text("Done")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .font(.system(size: 15, weight: .bold))
                    .multilineTextAlignment(.center)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            })
            .frame(width: 150)
            .background(Color(hex: "B098E6").opacity(1))
            .cornerRadius(10)
        }
        .onAppear {
            searchTextPlace = viewModel.placeTitle
            if !viewModel.placeTitle.isEmpty {
                items.insert(PlaceItem(customValue: viewModel.placeTitle))
            }
            if searchTextLocation != " • " {
                searchTextLocation = viewModel.placeAdresse
            }
        }
    }

    private var filteredItems: Set<PlaceItem> {
        
        if searchText.isEmpty {
            return items
        } else {
            let filtered = items.filter { item in
                item.value.lowercased().contains(searchText.lowercased())
            }

            var result = Set(filtered)
            if !filtered.contains(where: { $0.value.lowercased() == searchText.lowercased() }) {
                result.insert(PlaceItem(customValue: searchText))
            }
            
            return result
        }
    }
    
    private func addCustomLocation() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Vérifier si l'élément existe déjà (case insensitive)
        if !items.contains(where: { $0.value.lowercased() == trimmedText.lowercased() }) {
            let customItem = PlaceItem(customValue: trimmedText)
            items.insert(customItem)
        }
        
        // Sélectionner automatiquement le nouvel élément
        searchTextPlace = trimmedText
        searchText = ""
        isSearchFocused = false
    }
    
    private func toggleSelection(of item: PlaceItem) {
        withAnimation(.easeInOut(duration: 0.2)) {
            items.insert(item)

            if searchTextPlace != item.value {
                searchTextPlace = item.value
            } else {
                searchTextPlace = ""
            }
        }
    }
    
    func searchForLocation(completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)

        search.start { (response, error) in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }

            if let mapItem = response?.mapItems.first {
                selectedLocation = IdentifiableMapItem(mapItem: mapItem)
                mapRegion = MKCoordinateRegion(
                    center: mapItem.placemark.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )

                viewModel.placeLatitude = mapItem.placemark.coordinate.latitude
                viewModel.placeLongitude = mapItem.placemark.coordinate.longitude
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
