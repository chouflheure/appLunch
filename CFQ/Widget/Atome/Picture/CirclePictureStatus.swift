
import SwiftUI

struct CirclePictureStatusUserProfile: View {
    @State var image: Image?
    @ObservedObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack {
            Image(.header)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(viewModel.user.isActive ? .active : .inactive)
                )
        }
    }
}


struct CirclePictureStatus: View {
    @State var image: Image?
    var isActive: Bool
    var onClick: (() -> Void)

    var body: some View {
        ZStack {
            Image(.header)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(isActive ? .active : .inactive)
                )
        }.onTapGesture {
            Logger.log("click on picture", level: .action)
            onClick()
        }
    }
}
