
import SwiftUI

struct NameSignUpScreen: View {
    @State private var index = 0
    @ObservedObject var viewModel: SignUpPageViewModel

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(Strings.Login.TitleWhichIsYourIdentifier)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    TextFieldBGBlackFull(text: $viewModel.name, keyBoardType: .default, placeHolder: "Nom")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)

                    TextFieldBGBlackFull(text: $viewModel.name, keyBoardType: .default, placeHolder: "prenom")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    TextFieldBGBlackFull(text: $viewModel.name, keyBoardType: .default, placeHolder: "Pseudo")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                }

                Spacer()

                VStack {
                    FullButtonLogIn(
                        action: {viewModel.goNext()},
                        title: Strings.Login.CheckConfirmCode,
                        largeButtonType: .signNext
                    ).padding(.horizontal, 20)

                    FullButtonLogIn(
                        action: {viewModel.goBack()},
                        title: Strings.Login.DontReceiveCode,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    NameSignUpScreen(viewModel: .init())
}
