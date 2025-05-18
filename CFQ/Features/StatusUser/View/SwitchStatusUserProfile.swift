
import SwiftUI

struct SwitchStatusUserProfile: View {
    @StateObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack{
            CirclePictureStatusUserProfile(viewModel: viewModel)
                .frame(width: 72, height: 72)
            CustomToggleStatus(viewModel: viewModel)
                .offset(y: 40)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
    }.ignoresSafeArea()
}

