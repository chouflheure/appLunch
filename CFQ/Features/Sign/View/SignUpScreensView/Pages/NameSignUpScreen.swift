
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
                    Text(StringsToken.Sign.TitleWhichIsYourIdentifier)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    CustomTextField(text: $viewModel.name, keyBoardType: .default, placeHolder: "Nom", textFieldType: .sign)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)

                    CustomTextField(text: $viewModel.name, keyBoardType: .default, placeHolder: "prenom", textFieldType: .sign)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    CustomTextField(text: $viewModel.name, keyBoardType: .default, placeHolder: "Pseudo", textFieldType: .sign)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {viewModel.goNext()},
                        title: StringsToken.Sign.CheckConfirmCode,
                        largeButtonType: .signNext
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: {viewModel.goBack()},
                        title: StringsToken.Sign.DontReceiveCode,
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
