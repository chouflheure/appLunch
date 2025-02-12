
import SwiftUI

struct ItemViewHours: View {
    let hours: String
    let isSelected: Bool

    var body: some View {
        Text(hours)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: isSelected ? 0.9 : 0.3)
                    .animation(.bouncy, value: isSelected)
                    .shadow(radius: isSelected ? 5 : 1)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            )
    }
}
