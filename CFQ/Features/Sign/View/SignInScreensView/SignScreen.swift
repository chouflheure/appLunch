
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
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, 100)

                    VStack {
                        Text(viewModel.hasAlreadyAccount ?
                             Strings.Login.Connexion :
                                Strings.Login.Inscritpion).font(AppFont.GigalypseTrial.font(size: 12))
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)

                        TextFieldBGBlackFull(
                            text: $viewModel.phoneNumber,
                            keyBoardType: .phonePad,
                            placeHolder: Strings.Login.PlaceholderPhoneNumber
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)

                    Spacer()

                    VStack {
                        FullButtonLogIn(
                            action: {viewModel.sendVerificationCode()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Login.SendConfirmCode :
                                Strings.Login.Inscritpion,
                            color: .blackMain
                        ).padding(.horizontal, 20)

                        PurpleButtonLogIn(
                            action: {viewModel.toggleHasAlreadyAccount()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Login.NoAccount :
                                Strings.Login.AlreadyAccount
                        )}
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
