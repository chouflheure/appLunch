
import SwiftUI

struct CirclePictureStatusUserProfile: View {
    @State var image: Image?
    @ObservedObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack {
            CachedAsyncImageView(urlString: viewModel.user.profilePictureUrl)
        }
    }
}


struct CirclePictureStatus: View {
    var userPreview: UserContact
    var onClick: (() -> Void)

    var body: some View {
        ZStack {
            CachedAsyncImageView(urlString: userPreview.profilePictureUrl)
        }.onTapGesture {
            Logger.log("click on picture", level: .action)
            onClick()
        }
    }
}
