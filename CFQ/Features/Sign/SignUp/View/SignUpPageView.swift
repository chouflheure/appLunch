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
    
            LocalisationSignUpScreen(viewModel: viewModel)
                .tag(1)
                
            PictureSignUpScreen(viewModel: viewModel)
                .tag(2)
                
            FriendSignUpScreen(viewModel: viewModel, coordinator: coordinator) {
                dismiss()
            }
            .tag(3)
        }
    }

    @ViewBuilder
    func destinationView(for screen: Int) -> some View {
        switch screen {
        case 0:
            NameSignUpScreen(viewModel: viewModel) { dismiss() }

        case 1:
            LocalisationSignUpScreen(viewModel: viewModel)
            
        case 2:
            PictureSignUpScreen(viewModel: viewModel)
            
        case 3:
            FriendSignUpScreen(viewModel: viewModel, coordinator: coordinator) { dismiss() }

        default:
            NameSignUpScreen(viewModel: viewModel) { dismiss() }
        }
    }
}

#Preview {
    SignUpPageView(
        viewModel: SignUpPageViewModel(uidUser: ""), coordinator: Coordinator())
}
