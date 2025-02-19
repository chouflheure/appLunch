
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
                    Text(StringsToken.Sign.TitleWhichIsYourLocalisation)
                        .tokenFont(.Title_Gigalypse_24)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    CustomTextField(
                        text: $viewModel.localisation,
                        keyBoardType: .default,
                        placeHolder: "Ta loc",
                        textFieldType: .sign
                    )
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
                        title: StringsToken.Sign.TitleBackStep,
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

// TODO: Add reconnaissance localisation
