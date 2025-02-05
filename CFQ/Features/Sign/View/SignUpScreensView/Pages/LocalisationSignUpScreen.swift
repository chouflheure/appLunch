
import SwiftUI

struct LocalisationSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(Strings.Login.TitleWhichIsYourBirthday)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    TextFieldBGBlackFull(text: $viewModel.name, keyBoardType: .default, placeHolder: "01/01/2000")
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
                        title: Strings.Login.TtitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    LocalisationSignUpScreen(viewModel: .init())
}
