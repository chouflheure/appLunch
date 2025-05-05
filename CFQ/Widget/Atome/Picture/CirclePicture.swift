
import SwiftUI
import Lottie

struct CirclePicture: View {
    var urlStringImage: String
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: urlStringImage) ?? URL(string: " ")) { phase in
                switch phase {
                case .empty:
                    animation
                        .playing()
                        .looping()
                        
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())

                case .failure(_):
                    animation
                        .playing()
                        .looping()
                @unknown default:
                    animation
                        .playing()
                        .looping()
                }
            }
        }
    }
}
