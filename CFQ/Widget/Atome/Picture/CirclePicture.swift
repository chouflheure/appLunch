
import SwiftUI
import Lottie

struct CirclePicture: View {
    var urlStringImage: String
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        ZStack {
            CachedAsyncImageView(urlString: urlStringImage, designType: .scaledToFill_Circle)
        }
    }
}
