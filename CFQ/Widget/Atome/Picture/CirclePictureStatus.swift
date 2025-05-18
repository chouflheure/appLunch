
import SwiftUI

struct CirclePictureStatusUserProfile: View {
    @ObservedObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack {
            CachedAsyncImageView(urlString: viewModel.user.profilePictureUrl, designType: .scaledToFill_Circle)
                .shadow(color: viewModel.user.isActive ? .active : .inactive, radius: 4)
        }
        .overlay {
            Circle()
                .stroke(viewModel.user.isActive ? .active : .inactive, lineWidth: 2)
                .frame(width: 72, height: 72)
        }
    }
}


struct CirclePictureStatus: View {
    var userPreview: UserContact
    var onClick: (() -> Void)

    var body: some View {
        ZStack {
            CachedAsyncImageView(urlString: userPreview.profilePictureUrl, designType: .scaledToFill_Circle)
                .shadow(color: userPreview.isActive ? .active : .inactive, radius: 4)
        }
        .overlay {
            Circle()
                .stroke(userPreview.isActive ? .active : .inactive, lineWidth: 2)
                .frame(width: 72, height: 72)
        }
        .onTapGesture {
            Logger.log("click on picture", level: .action)
            onClick()
        }
    }
}
