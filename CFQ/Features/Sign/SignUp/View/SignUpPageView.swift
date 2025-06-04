import SwiftUI

enum ScreensSignUpType {
    case nameSignUpScreen
    case localisationSignUpScreen
    case pictureSignUpScreen
    case friendSignUpScreen
}

struct SignUpPageView: View {
    @StateObject var viewModel: SignUpPageViewModel
    @Environment(\.dismiss) var dismiss
    var coordinator: Coordinator
    var selectedDestination = ScreensSignUpType.nameSignUpScreen
    
    var body: some View {
        TabView(selection: $viewModel.index) {
            NameSignUpScreen(viewModel: viewModel) {
                dismiss()
            }
            .tag(0)
    
            BirthdaySignUpScreen(viewModel: viewModel)
                .tag(1)

            LocalisationSignUpScreen(viewModel: viewModel)
                .tag(2)
                
            PictureSignUpScreen(viewModel: viewModel)
                .tag(3)
                
            FriendSignUpScreen(viewModel: viewModel, coordinator: coordinator) {
                dismiss()
            }
            .tag(4)
        }
    }
}

#Preview {
    SignUpPageView(
        viewModel: SignUpPageViewModel(uidUser: ""), coordinator: Coordinator())
}
