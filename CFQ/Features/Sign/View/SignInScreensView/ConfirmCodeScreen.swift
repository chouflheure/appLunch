
import SwiftUI
import FirebaseAuth

struct ConfirmationScreenDestination: Hashable {}

struct ConfirmCodeScreen: View {
    @State private var otpCode = ""
    @State private var hasAlreadyAccount = true

    var verificationID: String
    var mobileNumber: String
    @Environment(\.dismiss) var dismiss
    
    func verifyCode() {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpCode)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Erreur: \(error.localizedDescription)")
                return
            }
            
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                print("Connexion réussie ✅ - UID: \(uid)")
            }

            dismiss()
        }
    }

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                Image(.whiteLogo)
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .edgesIgnoringSafeArea(.top)
                    .padding(.top, 120)

                VStack {
                    Text(Strings.Login.ConfirmationCode)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)

                    TextFieldBGBlackFull(
                        text: $otpCode,
                        keyBoardType: .phonePad,
                        placeHolder: Strings.Login.PlaceholderConfimCode
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.top, 50)

                Spacer()

                VStack {
                    FullButtonLogIn(
                        action: {verifyCode()},
                        title: Strings.Login.CheckConfirmCode
                    ).padding(.horizontal, 20)

                    PurpleButtonLogIn(
                        action: {},
                        title: Strings.Login.DontReceiveCode
                    )}
                .padding(.bottom, 100)
            }
        }
    }

}

#Preview {
    //ConfirmCodeScreen()
}
