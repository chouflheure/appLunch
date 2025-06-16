import Lottie
import SwiftUI

struct SignScreen: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject private var viewModel = SignInViewModel()
    @EnvironmentObject var user: User

    @State var isSignFinish = false
    @State private var toast: Toast? = nil
    @State private var isLoadingSendButton = false

    var body: some View {
        VStack {
            Image(.whiteLogo)
                .resizable()
                .scaledToFit()

            VStack {
                Text(StringsToken.Sign.Connexion)
                    .tokenFont(.Title_Gigalypse_24)
                    .textCase(.uppercase)
                    .padding(.bottom, 20)

                CustomTextField(
                    text: $viewModel.phoneNumber,
                    keyBoardType: .phonePad,
                    placeHolder: "06 ...",
                    textFieldType: .signUp
                )
            }

            Spacer()

            VStack {
                if isLoadingSendButton {
                    LottieView(
                        animation: .named(
                            StringsToken.Animation.loaderCircle
                        )
                    )
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
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
                        title: StringsToken.Sign.Connexion,
                        largeButtonType: .signNext,
                        isDisabled: viewModel.phoneNumber.isEmpty
                    )

                    LargeButtonView(
                        action: {
                            viewModel.signInGuestMode()
                        },
                        title: StringsToken.Sign.GuestMode,
                        largeButtonType: .signBack
                    )
                }
            }
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
                // EDIT 
                // NativeTabViewSolution(coordinator: coordinator)
                CustomTabView(coordinator: coordinator)
                    .environmentObject(user)
            } else {
                SignUpPageView(
                    viewModel: SignUpPageViewModel(
                        uidUser: viewModel.uidUser,
                        phoneNumber: viewModel.formattedNumber
                    ),
                    coordinator: coordinator
                )
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
        .toastView(toast: $toast)
        .onChange(of: viewModel.isConfirmScreenActive || viewModel.isSignFinish) {
            isLoadingSendButton = $0
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    SignScreen(coordinator: .init())
}
