
import SwiftUI

struct GradientCardView: View {
    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(hex: "111113"), location: 0.0),
                    Gradient.Stop(color: Color(hex: "111113"), location: 0.4),
                    Gradient.Stop(color: Color(hex: "4B6569"), location: 1.0)
                ]),
                startPoint: .bottom,
                endPoint: .topTrailing
            )
        }
        .frame(height: 500)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}
