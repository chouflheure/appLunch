
import SwiftUI
import Lottie

struct CirclePictureStatusUserProfile: View {
    @State var image: Image?
    @ObservedObject var viewModel: SwitchStatusUserProfileViewModel
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: viewModel.user.profilePictureUrl)!) { phase in
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
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(viewModel.user.isActive ? .active : .inactive)
                        )
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


struct CirclePictureStatus: View {
    var userPreview: UserContact
    var onClick: (() -> Void)
    let animation = LottieView(animation: .named(StringsToken.Animation.loaderPicture))

    var body: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: userPreview.profilePictureUrl)!) { phase in
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
                        .overlay(
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(userPreview.isActive ?? false ? .active : .inactive)
                        )
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
        }.onTapGesture {
            Logger.log("click on picture", level: .action)
            onClick()
        }
    }
}
