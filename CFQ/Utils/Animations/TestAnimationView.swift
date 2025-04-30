
import SwiftUI
import Lottie

private struct TestAnimationView: View {

    var body: some View {
        SafeAreaContainer {
            Text("Test Animation")
                .tokenFont(.Title_Gigalypse_24)
            
            LottieView(animation: .named(StringsToken.Animation.loaderHand))
                .playing()
                .looping()
            
            LottieView(animation: .named(StringsToken.Animation.loaderUpdatePicture))
                .playbackMode(.playing(
                    .fromFrame(
                        1,
                        toFrame: 95,
                        loopMode: .loop
                    )
                ))
            
            LottieView(animation: .named(StringsToken.Animation.loaderUpdatePicture))
                .playbackMode(.playing(
                    .fromFrame(
                        95,
                        toFrame: 180,
                        loopMode: .loop
                    )
                ))
            
            LottieView(animation: .named(StringsToken.Animation.loaderError))
                .playbackMode(.playing(
                    .fromFrame(
                        90,
                        toFrame: 151,
                        loopMode: .loop
                    )
                ))

            LottieView(animation: .named(StringsToken.Animation.rocketMAJ))
                .playing()
                .looping()
            
            LottieView(animation: .named(StringsToken.Animation.rocketMAJ_WithoutSmoke))
                .playing()
                .looping()
                
        }
    }
}

#Preview {
    TestAnimationView()
}
