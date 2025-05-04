
import FirebaseAuth
import SwiftUI
import Lottie

struct ConfirmCodeScreen: View {
    @State private var otpCode = ""
    @State private var hasAlreadyAccount = true
    @State private var toast: Toast? = nil

    @ObservedObject var viewModel: SignInViewModel

    var verificationID: String
    var mobileNumber: String
    @State private var isLoadingSendButton = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        SafeAreaContainer {

            VStack {
                ZStack(alignment: .top) {
                    Image(.whiteLogo)
                        .resizable()
                        .scaledToFit()
                    
                    HStack {
                        Spacer()

                        Button(action: {
                            dismiss()
                            viewModel.isConfirmScreenActive = false
                        }) {
                            Image(.iconCross)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.all, 7)
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 0.5)
                                }
                        }
                    }
                }

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
                        LottieView(animation: .named(StringsToken.Animation.loaderCircle))
                            .playing()
                            .looping()
                            .frame(width: 150, height: 150)
                    } else {
                        LargeButtonView(
                            action: {
                                isLoadingSendButton = true
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

                                    isLoadingSendButton = false
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
                                            message: "Le code a été renvoyé"
                                        )
                                        viewModel.startTimer10s()
                                    } else {
                                        toast = Toast(
                                            style: .error, message: message)
                                    }
                                }
                            },
                            title: StringsToken.Sign.DontReceiveCode,
                            largeButtonType: .signBack,
                            isDisabled: !viewModel.isEnabledResendCode
                        )
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            viewModel.startTimer10s()
            isLoadingSendButton = false
        }
        .toastView(toast: $toast)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
    
    
}

#Preview {
    ConfirmCodeScreen(viewModel: SignInViewModel(), verificationID: "", mobileNumber: "")
}
