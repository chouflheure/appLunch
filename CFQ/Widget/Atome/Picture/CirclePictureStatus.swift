
import SwiftUI

struct CirclePictureStatus: View {
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
