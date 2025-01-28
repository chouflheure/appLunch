
import SwiftUI

struct SignScreen: View {
    @State private var text: String = ""
    @StateObject private var viewModel = SignInScreenViewModel()
    @StateObject private var coordinator = SignCoordinator()

    var body: some View {
        NavigationStack {
            ZStack {
                NeonBackgroundImage()
                
                VStack {
                    
                    Image(.logoWhite)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .edgesIgnoringSafeArea(.top)
                        .padding(.top, 100)
                    
                    VStack {
                        Text(viewModel.hasAlreadyAccount ?
                             Strings.Login.Connexion :
                                Strings.Login.Inscritpion)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)
                        
                        TextFieldBGBlackFull(
                            text: $text,
                            keyBoardType: .phonePad,
                            placeHolder: Strings.Login.PlaceholderPhoneNumber
                        )
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    VStack {
                        FullButtonLogIn(
                            action: {coordinator.goToConfirmCode()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Login.SendConfirmCode :
                                Strings.Login.Inscritpion
                        ).padding(.horizontal, 20)
                        
                        PurpleButtonLogIn(
                            action: {viewModel.toggleHasAlreadyAccount()},
                            title: viewModel.hasAlreadyAccount ?
                            Strings.Login.NoAccount :
                                Strings.Login.AlreadyAccount
                        )}
                    .padding(.bottom, 100)
                }
                .navigationDestination(isPresented: $coordinator.isConfirmScreenActive) {
                    ConfirmCodeScreen()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }

}

#Preview {
    SignScreen()
}
