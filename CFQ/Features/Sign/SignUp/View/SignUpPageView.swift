import SwiftUI

struct SignUpPageView: View {
    @StateObject var viewModel: SignUpPageViewModel
    @Environment(\.dismiss) var dismiss
    var coordinator: Coordinator

    var body: some View {
        TabView(selection: $viewModel.index) {
             NameSignUpScreen(viewModel: viewModel) {
             dismiss()
             }.tag(0)
             
             LocalisationSignUpScreen(viewModel: viewModel)
             .tag(1)
             
             PictureSignUpScreen(viewModel: viewModel)
             .tag(2)
             
            FriendSignUpScreen(viewModel: viewModel, coordinator: coordinator) {
                dismiss()
            }
             .tag(3)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    // SignUpPageView(viewModel: SignUpPageViewModel(uidUser: ""))
}
