
import SwiftUI
import FirebaseAuth

struct SignScreen: View {
    @StateObject private var viewModel = SignInScreenViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                NeonBackgroundImage()

                VStack {
                    Image(.whiteLogo)
                        .resizable()
                        .padding(.horizontal, 30)
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, 100)

                    VStack {
                        Text(viewModel.hasAlreadyAccount ?
                             StringsToken.Sign.Connexion :
                                StringsToken.Sign.Inscritpion)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)
                        
                        CustomTextField(
                            text: $viewModel.phoneNumber,
                            keyBoardType: .phonePad,
                            placeHolder: StringsToken.Sign.PlaceholderPhoneNumber,
                            textFieldType: .sign
                        ).padding(.horizontal, 20)
                    }
                    .padding(.top, 40)

                    Spacer()

                    VStack {
                        LargeButtonView(
                            action: {viewModel.sendVerificationCode()},
                            title: viewModel.hasAlreadyAccount ?
                            StringsToken.Sign.SendConfirmCode :
                                StringsToken.Sign.Inscritpion,
                            largeButtonType: .signNext
                        ).padding(.horizontal, 20)
                        
                        LargeButtonView(
                            action: {viewModel.toggleHasAlreadyAccount()},
                            title: viewModel.hasAlreadyAccount ?
                            StringsToken.Sign.NoAccount :
                                StringsToken.Sign.AlreadyAccount,
                            largeButtonType: .signBack
                        ).padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
                .navigationDestination(isPresented: $viewModel.isConfirmScreenActive) {
                    ConfirmCodeScreen(verificationID: viewModel.verificationID, mobileNumber: viewModel.phoneNumber)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }    
}

#Preview {
    SignScreen()
}
