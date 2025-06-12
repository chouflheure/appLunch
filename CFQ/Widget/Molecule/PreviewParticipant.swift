import SwiftUI

struct PreviewProfile: View {
    var pictures: [String]
    var previewProfileType: PreviewProfileType
    var numberUsers: Int
    var isLoading: Bool = false  // Nouveau paramètre

    var body: some View {
        HStack {
            if isLoading {
                // Placeholder avec cercles gris
                HStack(spacing: -15) {
                    ForEach(0..<min(3, numberUsers), id: \.self) { _ in
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                }
                .redacted(reason: .placeholder)  // Effet de shimmer
            } else {
                PreviewMultiplePicture(pictures: pictures)
            }
            
            Text("\(numberUsers)")
                .foregroundStyle(.white)
                .bold()
            Text(previewProfileType.rawValue)
                .foregroundStyle(.white)
        }
    }
}
