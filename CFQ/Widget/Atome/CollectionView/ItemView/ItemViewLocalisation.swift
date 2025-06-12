
import SwiftUI

struct ItemViewLocalisation: View {
    let city: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Text(city)
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .lineLimit(1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.white.opacity(0.1) : Color.clear)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? Color.white : Color.white.opacity(0.3),
                    lineWidth: isSelected ? 2 : 1
                )
                .shadow(
                    color: isSelected ? Color.white.opacity(0.3) : Color.clear,
                    radius: isSelected ? 8 : 0
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}
