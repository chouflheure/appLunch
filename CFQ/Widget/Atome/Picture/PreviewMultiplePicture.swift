
import SwiftUI

struct PreviewMultiplePicture: View {
    
    var pictures: [String]
    
    var body: some View {
        HStack(spacing: -15) {
            ForEach(pictures.count < 4 ? pictures.indices : 0..<4, id: \.self) { index in
                CachedAsyncImageView(
                    urlString: pictures[index],
                    designType: .scaleImageMessageProfile
                )
            }
        }.onAppear {
            print("@@@ cached")
        }
    }
}
