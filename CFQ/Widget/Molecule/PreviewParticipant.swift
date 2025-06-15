
import SwiftUI

struct PreviewProfile: View {
    @Binding var friends: [UserContact]?
    @Binding var showImages: Bool
    var previewProfileType: PreviewProfileType

    var body: some View {
        HStack {
            Group {
                if !showImages {
                    // Placeholder
                    HStack(spacing: -15) {
                        ForEach(0..<min(4, friends?.count ?? 4), id: \.self) {
                            index in
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                    }
                } else {
                    // Images réelles
                    HStack(spacing: -15) {
                        ForEach(
                            Array(
                                (friends?.compactMap({ $0.profilePictureUrl })
                                    ?? []).prefix(4).enumerated()), id: \.offset
                        ) { index, imageUrl in
                            CachedAsyncImageView(
                                urlString: imageUrl,
                                designType: .scaleImageMessageProfile
                            )
                        }
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showImages)

            Text("\(friends?.count ?? 0)")
                .foregroundStyle(.white)
                .bold()
            
            Text(previewProfileType.rawValue)
                .foregroundStyle(.white)
        }
        .frame(height: 24)

    }
}
