
import SwiftUI

struct TestViewContentView: View {
    let viewModel = SignUpPageViewModel(uidUser: "")
    func pictureAdd() {
        viewModel.picture = UIImage(resource: .crown)
    }
    
    var body: some View {
        FriendSignUpScreen(
            viewModel: viewModel,
            coordinator: Coordinator(),
            onDismiss: {}
        ).onAppear() {
            pictureAdd()
        }
    }
}

