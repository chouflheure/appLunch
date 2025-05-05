
import SwiftUI
import Lottie

private struct TestAnimationView: View {

    var body: some View {
        SafeAreaContainer {
            
            Text("Test Animation")
                .tokenFont(.Title_Gigalypse_24)
            
            ScrollView {
                
                LottieView(animation: .named(StringsToken.Animation.loaderPicture))
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.loaderHand))
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.loaderUpdatePicture))
                    .playbackMode(.playing(
                        .fromFrame(
                            1,
                            toFrame: 95,
                            loopMode: .loop
                        )
                    ))
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.loaderUpdatePicture))
                    .playbackMode(.playing(
                        .fromFrame(
                            95,
                            toFrame: 180,
                            loopMode: .loop
                        )
                    ))
                    .frame(width: 150, height: 150)

                LottieView(animation: .named(StringsToken.Animation.loaderError))
                    .playbackMode(.playing(
                        .fromFrame(
                            90,
                            toFrame: 151,
                            loopMode: .loop
                        )
                    ))
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.loaderCircle))
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.rocketMAJ))
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                
                LottieView(animation: .named(StringsToken.Animation.rocketMAJ_WithoutSmoke))
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
            }
        }
    }
}

#Preview {
    TestAnimationView()
}
