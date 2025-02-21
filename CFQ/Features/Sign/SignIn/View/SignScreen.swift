import SwiftUI

struct SignScreen: View {
    @StateObject private var viewModel = SignInViewModel()
    @State private var toast: Toast? = nil

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)
                
                VStack {
                    Text(
                        viewModel.hasAlreadyAccount
                            ? StringsToken.Sign.Connexion
                            : StringsToken.Sign.Inscritpion
                    )
                    .tokenFont(.Title_Gigalypse_24)
                    .textCase(.uppercase)
                    .padding(.bottom, 20)

                    CustomTextField(
                        text: $viewModel.phoneNumber,
                        keyBoardType: .phonePad,
                        placeHolder: StringsToken.Sign
                            .PlaceholderPhoneNumber,
                        textFieldType: .sign
                    )
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {
                            viewModel.sendVerificationCode {
                                success, message in
                                if !success {
                                    toast = Toast(
                                        style: .error, message: message)
                                }
                            }
                        },
                        title: viewModel.hasAlreadyAccount
                            ? StringsToken.Sign.SendConfirmCode
                            : StringsToken.Sign.Inscritpion,
                        largeButtonType: .signNext,
                        isDisabled: viewModel.phoneNumber.isEmpty
                    )

                    LargeButtonView(
                        action: {
                            viewModel.toggleHasAlreadyAccount()
                        },
                        title: viewModel.hasAlreadyAccount
                            ? StringsToken.Sign.NoAccount
                            : StringsToken.Sign.AlreadyAccount,
                        largeButtonType: .signBack
                    )
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 16)
            .sheet(isPresented: $viewModel.isConfirmScreenActive) {
                ConfirmCodeScreen(
                    viewModel: viewModel,
                    verificationID: viewModel.verificationID,
                    mobileNumber: viewModel.phoneNumber
                )
                .navigationBarBackButtonHidden(true)
            }
            .fullScreenCover(isPresented: $viewModel.isSignFinish) {
                if viewModel.isUserExist {
                    Text("Hello")
                } else {
                    SignUpPageView(viewModel: SignUpPageViewModel(uidUser: viewModel.uidUser))
                }
            }
        }
        .toastView(toast: $toast)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }

    }
}

#Preview {
    SignScreen()
}
