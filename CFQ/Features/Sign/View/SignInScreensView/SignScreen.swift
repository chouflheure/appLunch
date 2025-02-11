
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
                             Strings.Sign.Connexion :
                                Strings.Sign.Inscritpion).font(AppFont.GigalypseTrial.font(size: 12))
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)
                        
                        CustomTextField(
                            text: $viewModel.phoneNumber,
                            keyBoardType: .phonePad,
                            placeHolder: Strings.Sign.PlaceholderPhoneNumber,
                            textFieldType: .sign
                        ).padding(.horizontal, 20)
                    }
                    .padding(.top, 40)

                    Spacer()

                    VStack {
                        LargeButtonView(
                            action: {viewModel.sendVerificationCode()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Sign.SendConfirmCode :
                                Strings.Sign.Inscritpion,
                            largeButtonType: .signNext
                        ).padding(.horizontal, 20)
                        
                        LargeButtonView(
                            action: {viewModel.toggleHasAlreadyAccount()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Sign.NoAccount :
                                Strings.Sign.AlreadyAccount,
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
