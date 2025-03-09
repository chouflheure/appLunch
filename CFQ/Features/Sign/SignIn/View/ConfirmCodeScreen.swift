import FirebaseAuth
import SwiftUI

struct ConfirmCodeScreen: View {
    @State private var otpCode = ""
    @State private var hasAlreadyAccount = true
    @State private var toast: Toast? = nil

    @State var viewModel: SignInViewModel
    var verificationID: String
    var mobileNumber: String

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)

                VStack {
                    Text(StringsToken.Sign.ConfirmationCode)
                        .tokenFont(.Title_Gigalypse_24)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)

                    CustomTextField(
                        text: $otpCode,
                        keyBoardType: .phonePad,
                        placeHolder: StringsToken.Sign.PlaceholderConfimCode,
                        textFieldType: .sign
                    ).textContentType(.oneTimeCode)
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {
                            viewModel.verifyCode(for: otpCode) {
                                success, message in
                                if success {
                                    dismiss()
                                } else {
                                    toast = Toast(
                                        style: .error, message: message ?? "Error not found")
                                }
                            }
                        },
                        title: StringsToken.Sign.CheckConfirmCode,
                        largeButtonType: .signNext,
                        isDisabled: otpCode.isEmpty
                    )
                    LargeButtonView(
                        action: {
                            viewModel.dontReciveVerificationCode {
                                success, message in
                                if success {
                                    toast = Toast(
                                        style: .success,
                                        message: "Le code a été renvoyé")
                                } else {
                                    toast = Toast(
                                        style: .error, message: message)
                                }
                            }
                        },
                        title: StringsToken.Sign.DontReceiveCode,
                        largeButtonType: .signBack
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 16)
        }
        .toastView(toast: $toast)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
}
