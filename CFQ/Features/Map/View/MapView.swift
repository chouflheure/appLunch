import MapKit
import SwiftUI

struct MapLocationEventData: Identifiable {
    var id: String?  // Add here ID de l'event
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String?
    let imageName: String?
}

struct TestMap: View {
    @Binding var selectedEvent: MapLocationEventData?
    @ObservedObject var coordinator: Coordinator

    let locations = [
        MapLocationEventData(
            coordinate: CLLocationCoordinate2D(
                latitude: 48.858844, longitude: 2.294351), title: "Anniv Paul",
            subtitle: "", imageName: ""),
        MapLocationEventData(
            coordinate: CLLocationCoordinate2D(
                latitude: 48.860611, longitude: 2.337644), title: "Louvre",
            subtitle: "", imageName: ""),
    ]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.860611, longitude: 2.337644),  // Centre de Paris
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State var isPresentedSheet: Bool = false

    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) {
                Map {
                    Annotation(
                        locations[0].title,
                        coordinate: locations[0].coordinate,
                        anchor: .bottom
                    ) {
                        ZStack {
                            Image(.header)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            style: StrokeStyle(lineWidth: 2)
                                        )
                                        .foregroundColor(.active)
                                )
                        }.onTapGesture {
                            isPresentedSheet = true
                        }
                    }
                    
                    Annotation(
                        locations[1].title,
                        coordinate: locations[1].coordinate,
                        anchor: .bottom
                    ) {
                        ZStack {
                            Image(.header)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(
                                            style: StrokeStyle(lineWidth: 2)
                                        )
                                        .foregroundColor(.active)
                                )
                        }.onTapGesture {
                            isPresentedSheet = true
                        }
                    }
                }
                .mapStyle(.standard(pointsOfInterest: []))
                .ignoresSafeArea()
                .sheet(isPresented: $isPresentedSheet) {
                    TestPreviewEvent()
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(400)])
                }

            } else {
                MapView(
                    locations: [
                        MapLocationEventData(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 48.8566, longitude: 2.3522),
                            title: "Paris",
                            subtitle: "La ville lumière",
                            imageName: "Header"
                        ),
                        MapLocationEventData(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 48.8570, longitude: 2.3533),
                            title: "Paris",
                            subtitle: "La ville lumière",
                            imageName: "profile"
                        ),
                        MapLocationEventData(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 45.764, longitude: 4.8357),
                            title: "Lyon",
                            subtitle: "Capitale de la gastronomie",
                            imageName: "profile"
                        ),
                        MapLocationEventData(
                            coordinate: CLLocationCoordinate2D(
                                latitude: 43.6045, longitude: 1.4442),
                            title: "Toulouse",
                            subtitle: "La ville rose",
                            imageName: "backgroundNeon"
                        ),
                    ], selectedEvent: $selectedEvent)
            }

            // Indicator FullScreen or Close
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            coordinator.showMapFullScreen.toggle()
                        }
                    }) {
                        Image(systemName:
                            coordinator.showMapFullScreen ? "xmark" :
                                "arrow.down.left.and.arrow.up.right.rectangle.fill"
                        )
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color(hex: "B098E6"))
                        .padding(.all, 5)
                        .background(.black)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(Color(hex: "B098E6"), lineWidth: 2)
                        }
                        
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                Spacer()
            }
        }
    }
}

struct TestPreviewEvent: View {
    var body: some View {
        Spacer()
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 15) {
                // Image
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)

                // Title
                VStack(alignment: .center, spacing: 15) {
                    HStack {
                        Spacer()
                        Text("Anniv de Paul")
                            .tokenFont(.Title_Gigalypse_20)
                            .padding(.top, 30)
                            .padding(.horizontal, 15)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Text("Aujourd'hui ")
                            .tokenFont(.Body_Inter_Medium_16)
                        Text(" | ")
                            .tokenFont(.Body_Inter_Medium_16)
                        Text("20h")
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                    
                    // Address
                    Text("10 rue de Lamartine")
                        .tokenFont(.Body_Inter_Medium_16)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 15)
                }

                Divider()
                    .background(.white)

                // Description and Mood
                VStack(alignment: .leading, spacing: 10) {
                    Text("Diner entre girls <3 Ramenez juste à boire! Diner entre girls <3 Ramenez juste à boire! Diner \nentre girls <3 Ramenez juste à boire! Ramenez juste à boire")
                        .tokenFont(.Body_Inter_Medium_16)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 5)
                        .lineLimit(3)

                    HStack {
                        Mood().data(for: .after)
                        Mood().data(for: .bar)
                    }.padding(.top, 15)
                }
                
                .padding(.horizontal, 15) // Ensure padding aligns with other elements

                Spacer()
            }
            .frame(height: 400)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)
            .padding(.top, 40)
            .padding(.horizontal, 10)
        }
    }
}


#Preview {
    TestPreviewEvent()
}

#Preview {
    @State var selectedEvent: MapLocationEventData? = nil
    TestMap(selectedEvent: $selectedEvent, coordinator: Coordinator())
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
}

struct MapView: UIViewRepresentable {
    let locations: [MapLocationEventData]
    @Binding var selectedEvent: MapLocationEventData?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        // Centrer la carte sur le premier lieu
        if let firstLocation = locations.first {
            let region = MKCoordinateRegion(
                center: firstLocation.coordinate, latitudinalMeters: 50000,
                longitudinalMeters: 50000)
            mapView.setRegion(region, animated: true)
        }

        // Ajouter les annotations personnalisées
        let annotations = locations.map { location -> CustomAnnotation in
            let annotation = CustomAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            annotation.subtitle = location.subtitle
            annotation.imageName = location.imageName ?? ""

            return annotation
        }
        mapView.addAnnotations(annotations)

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("OpenEventDetail"), object: nil,
            queue: .main
        ) { notification in
            if let annotation = notification.object as? CustomAnnotation {
                DispatchQueue.main.async {
                    self.selectedEvent = MapLocationEventData(
                        coordinate: annotation.coordinate,
                        title: annotation.title ?? "Sans titre",
                        subtitle: annotation.subtitle ?? "",
                        imageName: annotation.imageName
                    )
                }
            }
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
            -> MKAnnotationView?
        {
            guard let annotation = annotation as? CustomAnnotation else {
                return nil
            }

            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(
                    annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            // Définir l’image personnalisée de chaque marqueur
            annotationView?.image = UIImage.roundedImage(
                named: annotation.imageName,
                size: CGSize(width: 40, height: 40),
                backgroundColor: .active,
                borderWidth: 1,
                borderColor: .active
            )

            // Ajouter une vue à gauche avec l’image du lieu
            let leftImageView = UIImageView(
                image: UIImage(named: annotation.imageName))
            let size = 40.0
            leftImageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
            leftImageView.layer.cornerRadius = size / 2
            leftImageView.clipsToBounds = true
            annotationView?.leftCalloutAccessoryView =
                annotation.imageName.isEmpty ? nil : leftImageView

            // **Ajout du bouton avec une flèche à droite**
            let arrowButton = UIButton(type: .custom)
            arrowButton.setImage(
                UIImage(systemName: "chevron.right"), for: .normal)
            arrowButton.tintColor = .active
            arrowButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            arrowButton.addTarget(
                self, action: #selector(openEventDetail(_:)),
                for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = arrowButton

            return annotationView
        }

        @objc func openEventDetail(_ sender: UIButton) {
            print("👉 Bouton cliqué ! Vérification en cours...")

            var superview = sender.superview
            while superview != nil, !(superview is MKAnnotationView) {
                superview = superview?.superview
            }

            guard let annotationView = superview as? MKAnnotationView,
                let annotation = annotationView.annotation as? CustomAnnotation
            else {
                print(
                    "⚠️ Impossible de récupérer l'annotation après recherche !")
                return
            }

            print(
                "✅ Ouverture de l'événement : \(annotation.title ?? "Sans titre")"
            )

            // Envoyer une notification pour ouvrir la page SwiftUI
            NotificationCenter.default.post(
                name: NSNotification.Name("OpenEventDetail"), object: annotation
            )
        }

    }
}

// **Modèle personnalisé pour stocker l'image du marqueur**
class CustomAnnotation: MKPointAnnotation {
    var imageName: String = ""
}

struct EventDetailView: View {
    let event: MapLocationEventData

    var body: some View {
        VStack {
            Text(event.title)
                .font(.largeTitle)
                .bold()

            Text(event.subtitle ?? "")
                .foregroundColor(.gray)

            if let image = UIImage(named: event.imageName ?? "") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
            }

            Spacer()
        }
        .padding()
    }
}
