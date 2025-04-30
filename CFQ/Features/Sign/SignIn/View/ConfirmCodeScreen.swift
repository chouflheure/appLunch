
import FirebaseAuth
import SwiftUI
import Lottie

struct ConfirmCodeScreen: View {
    @State private var otpCode = ""
    @State private var hasAlreadyAccount = true
    @State private var toast: Toast? = nil

    @State var viewModel: SignInViewModel
    var verificationID: String
    var mobileNumber: String
    @State private var isEnabledResendCode = false
    @State private var timer: Timer? = nil
    @State private var isLoadingSendButton = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        SafeAreaContainer {

            VStack {
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                    // .padding(.top, 30)

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
                    if isLoadingSendButton {
                        LottieView(animation: .named(StringsToken.Animation.loaderHand))
                            .playing()
                            .looping()
                    } else {
                        LargeButtonView(
                            action: {
                                viewModel.verifyCode(for: otpCode) {
                                    success, message in
                                    if success {
                                        dismiss()
                                    } else {
                                        toast = Toast(
                                            style: .error,
                                            message: message ?? "Error not found"
                                        )
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
                            largeButtonType: .signBack,
                            isDisabled: !isEnabledResendCode
                        )
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            startTimer()
            isLoadingSendButton = false
        }
        .toastView(toast: $toast)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
    
    func startTimer() {
            // Définir le délai en secondes (par exemple, 5 secondes)
        let delay = 10.0
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            isEnabledResendCode = true
        }
    }
}
