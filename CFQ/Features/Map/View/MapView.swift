//
//  MapView.swift
//  CFQ
//
//  Created by Calvignac Charles on 05/02/2025.
//

import SwiftUI
import MapKit



// Modèle pour chaque emplacement
struct MapLocation {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    let imageName: String // Nom de l’image dans Assets.xcassets
}


struct MapView: UIViewRepresentable {
    let locations: [MapLocation] // Liste des emplacements

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        // Centrer la carte sur le premier lieu
        if let firstLocation = locations.first {
            let region = MKCoordinateRegion(center: firstLocation.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            mapView.setRegion(region, animated: true)
        }

        // Ajouter les annotations personnalisées
        let annotations = locations.map { location -> CustomAnnotation in
            let annotation = CustomAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = location.title
            annotation.subtitle = location.subtitle
            annotation.imageName = location.imageName
            return annotation
        }
        mapView.addAnnotations(annotations)

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

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? CustomAnnotation else { return nil }

            let identifier = "CustomMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKAnnotationView

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            // Définir l’image personnalisée de chaque marqueur
            annotationView?.image = UIImage(named: annotation.imageName)?.roundedImage()?

            // Ajouter une vue à gauche avec l’image du lieu
            let leftImageView = UIImageView(image: UIImage(named: annotation.imageName))
            leftImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            leftImageView.layer.cornerRadius = 25 // Rendre l'image ronde
            leftImageView.clipsToBounds = true
            annotationView?.leftCalloutAccessoryView = leftImageView

            return annotationView
        }
    }
}

// **Modèle personnalisé pour stocker l'image du marqueur**
class CustomAnnotation: MKPointAnnotation {
    var imageName: String = ""
}


extension UIImage {
    func roundedImage() -> UIImage? {
        let minSide = min(size.width, size.height) // Utilise le plus petit côté
        let imageSize = CGSize(width: minSide, height: minSide)

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: imageSize)
            UIBezierPath(ovalIn: rect).addClip()
            self.draw(in: rect)
        }
    }
}

