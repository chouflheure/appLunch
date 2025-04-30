
import SwiftUI
import Lottie

struct SignScreen: View {
    @StateObject private var viewModel = SignInViewModel()
    @State private var toast: Toast? = nil
    var coordinator: Coordinator
    @EnvironmentObject var user: User
    @State var isSignFinish = false
    @State private var isLoadingSendButton = false

    var body: some View {
        SafeAreaContainer {
            VStack {
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()

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
                    if isLoadingSendButton {
                        LottieView(animation: .named(StringsToken.Animation.loaderHand))
                            .playing()
                            .looping()
                    } else {
                        LargeButtonView(
                            action: {
                                withAnimation {
                                    isLoadingSendButton = true
                                }
                                viewModel.sendVerificationCode {
                                    success, message in
                                    if !success {
                                        toast = Toast(
                                            style: .error,
                                            message: message
                                        )
                                        isLoadingSendButton = false
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
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 16)
            .fullScreenCover(isPresented: $viewModel.isConfirmScreenActive) {
                ConfirmCodeScreen(
                    viewModel: viewModel,
                    verificationID: viewModel.verificationID,
                    mobileNumber: viewModel.phoneNumber
                )
                .navigationBarBackButtonHidden(true)
            }
            .fullScreenCover(isPresented: $viewModel.isSignFinish) {
                if viewModel.isUserExist, let user = viewModel.user {
                    CustomTabView(coordinator: coordinator)
                        .environmentObject(user)
                } else {
                    SignUpPageView(viewModel: SignUpPageViewModel(uidUser: viewModel.uidUser), coordinator: coordinator)
                }
            }
        }
        .toastView(toast: $toast)
        .onAppear() {
            isLoadingSendButton = false
        }
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
}

#Preview {
    SignScreen(coordinator: .init())
}
