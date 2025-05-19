
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

struct ContentView8: View {
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

    var body: some View {
        VStack {
            TextField("Enter location name", text: $searchText, onEditingChanged: { _ in }, onCommit: {
                // Optional: Handle commit action if needed
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .padding(.top, 20)
            .onChange(of: searchText) { newValue in
                searchCompleter.updateQueryFragment(newValue)
            }

            ScrollView(showsIndicators: false) {
                ForEach(searchCompleter.results, id: \.self) { result in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(result.title)
                            Spacer()
                        }

                        HStack {
                            Text(result.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 12)
                    .onTapGesture {
                        viewModel.placeTitle = result.title
                        viewModel.placeAdresse = result.subtitle
                        searchForLocation(completion: result)
                        print("@@@ viewModel.adresse.placeTitle \(viewModel.placeTitle)")
                        print("@@@ viewModel.adresse.placeAdresse \(viewModel.placeAdresse)")
                    }
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        
                }
            }

/*
            List(searchCompleter.results, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title)
                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    viewModel.placeTitle = result.title
                    viewModel.placeAdresse = result.subtitle
                    searchForLocation(completion: result)
                    print("@@@ viewModel.adresse.placeTitle \(viewModel.placeTitle)")
                    print("@@@ viewModel.adresse.placeAdresse \(viewModel.placeAdresse)")
                }
            }
*/
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
                .background(Color(hex: "B098E6").opacity(viewModel.disableButtonSend ? 0.5 : 1))
                .cornerRadius(10)
                
                
                    /*
                    let latitude = selectedLocation.mapItem.placemark.coordinate.latitude
                    let longitude = selectedLocation.mapItem.placemark.coordinate.longitude
                    let googleSearchURLString = "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)"
                     */
                    /*
                    if let url = URL(string: googleSearchURLString) {
                        selectedURL = url
                        showingSafariView = true
                    }
                     */
                    
               
            }
        }
        /*
        .sheet(isPresented: $showingSafariView) {
            if let selectedURL = selectedURL {
                SafariView(url: selectedURL)
            }
        }
         */
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

                print("@@@ Found location: \(mapItem.name ?? "No name")")
                print("@@@ mapItem.placemark.coordinate: \(mapItem.placemark.coordinate.longitude)")
                print("@@@ mapItem.placemark.coordinate: \(mapItem.placemark.coordinate.latitude)")
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
