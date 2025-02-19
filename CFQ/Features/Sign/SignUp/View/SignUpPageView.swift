
import SwiftUI

struct SignUpPageView: View {
    @StateObject private var viewModel = SignUpPageViewModel()

    var body: some View {
        TabView(selection: $viewModel.index) {
            NameSignUpScreen(viewModel: viewModel)
                .tag(0)

            LocalisationSignUpScreen(viewModel: viewModel)
                .tag(1)

            PictureSignUpScreen(viewModel: viewModel)
                .tag(2)

            FriendSignUpScreen(viewModel: viewModel)
                .tag(3)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SignUpPageView()
}
