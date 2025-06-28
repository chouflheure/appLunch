
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
    @State private var searchText = ""
    @StateObject private var searchCompleter = SearchCompleter()
    @ObservedObject var viewModel: TurnCardViewModel
    @Binding var isPresented: Bool

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Paris coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var showingSafariView = false
    @State private var selectedURL: URL?
    @State private var selectedLocation: IdentifiableMapItem?
    @State private var selectedResult: MKLocalSearchCompletion?

    var body: some View {
        VStack(spacing: 0) {
            TextField("Où faire l'event ?", text: $searchText, onEditingChanged: { _ in }, onCommit: {})
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .padding(.top, 20)
            .onChange(of: searchText) { newValue in
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
                        }
                    }
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 12)
                }
            }
            
            /*
            if let selectedLocation = selectedLocation {
                ZStack {
                    Map(coordinateRegion: $mapRegion, annotationItems: [selectedLocation]) { location in
                        MapMarker(coordinate: location.mapItem.placemark.coordinate, tint: .red)
                    }
                    .frame(height: 300)
                }
                Button(action: {
                    isPresented = false
                }, label: {
                    Text("Done")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .font(.system(size: 15, weight: .bold))
                        .multilineTextAlignment(.center)
                })
                .frame(width: 150)
                .background(Color(hex: "B098E6").opacity(1))
                .cornerRadius(10)
            }
            */
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
