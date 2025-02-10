//
//  testMap.swift
//  CFQ
//
//  Created by Calvignac Charles on 10/02/2025.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @State private var route: MKRoute?
    @State private var travelTime: String?
    private let gradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [8, 8])
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Map {
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 8)
                    // .stroke(gradient, style: stroke)
                }
            }
            .overlay(alignment: .bottom, content: {
                HStack {
                    if let travelTime {
                        Text("Travel time: \(travelTime)")
                            .padding()
                            .font(.headline)
                            .foregroundStyle(.black)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                    }
                }
            })
            .onAppear(perform: {
                fetchRouteFrom(.empireStateBuilding, to: .columbiaUniversity)
            })
        } else {
            // Fallback on earlier versions
        }
    }
}
extension CLLocationCoordinate2D {
    static let weequahicPark = CLLocationCoordinate2D(latitude: 40.7063, longitude: -74.1973)
    static let empireStateBuilding = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
    static let columbiaUniversity = CLLocationCoordinate2D(latitude: 40.8075, longitude: -73.9626)
}
extension RouteView {
    
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            getTravelTime()
        }
    }
    
    private func getTravelTime() {
        guard let route else { return }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        travelTime = formatter.string(from: route.expectedTravelTime)
    }
}

#Preview {
    RouteView()
}
