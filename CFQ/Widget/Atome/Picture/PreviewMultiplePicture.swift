
import SwiftUI

struct PreviewMultiplePicture: View {
    var pictures: [String]
    
    var body: some View {
        HStack(spacing: -15) {
            ForEach(Array(pictures.prefix(4).enumerated()), id: \.offset) { index, pictureUrl in
                CachedAsyncImageView(
                    urlString: pictureUrl,
                    designType: .scaleImageMessageProfile
                )
            }
        }
    }
}
