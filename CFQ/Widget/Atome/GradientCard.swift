
import SwiftUI

struct GradientCardView: View {
    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(.blackMain), location: 0.0),
                    Gradient.Stop(color: Color(.blackMain), location: 0.4),
                    Gradient.Stop(color: Color(.grayCard), location: 1.0)
                ]),
                startPoint: .bottom,
                endPoint: .topTrailing
            )
        }
    }
}

struct GradientCardDetailView: View {
    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(.blackMain), location: 0.0),
                    Gradient.Stop(color: Color(.blackMain), location: 0.4),
                    Gradient.Stop(color: Color(.grayCard), location: 1.0)
                ]),
                startPoint: .bottom,
                endPoint: .topTrailing
            )
        }
    }
}
