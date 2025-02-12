
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
        .frame(height: 500)
        .cornerRadius(20)
        .padding(.horizontal, 12)
    }
}
