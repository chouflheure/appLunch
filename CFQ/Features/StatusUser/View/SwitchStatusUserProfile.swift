
import SwiftUI

struct SwitchStatusUserProfile: View {
    @ObservedObject var viewModel: SwitchStatusUserProfileViewModel

    var body: some View {
        ZStack{
            CirclePictureStatus(viewModel: viewModel)
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

