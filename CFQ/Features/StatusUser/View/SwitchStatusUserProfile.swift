
import SwiftUI

struct SwitchStatusUserProfile: View {
    @StateObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack{
            CirclePictureStatusUserProfile(viewModel: viewModel)
                .frame(width: 70, height: 70)
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

