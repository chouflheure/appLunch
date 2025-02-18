
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
                    Text(StringsToken.Sign.TitleWhichIsYourBirthday)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    CustomTextField(text:  $viewModel.name, keyBoardType: .default, placeHolder: "01/01/2000", textFieldType: .sign)
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
                        title: StringsToken.Sign.TtitleBackStep,
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
