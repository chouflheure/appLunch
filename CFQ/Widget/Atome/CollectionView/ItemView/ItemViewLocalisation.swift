
import SwiftUI

struct ItemViewLocalisation: View {
    let city: String
    let isSelected: Bool

    var body: some View {
        Text(city)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: isSelected ? 0.9 : 0)
                    .animation(.bouncy, value: isSelected)
                    .shadow(radius: isSelected ? 5 : 1)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            )
    }
}
