
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
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 30)

                VStack {
                    Text(StringsToken.Sign.ConfirmationCode)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 20)
                    
                    CustomTextField(
                        text: $otpCode,
                        keyBoardType: .phonePad,
                        placeHolder: StringsToken.Sign.PlaceholderConfimCode,
                        textFieldType: .sign
                    )
                }

                Spacer()

                VStack {
                    LargeButtonView(
                        action: {verifyCode()},
                        title: StringsToken.Sign.CheckConfirmCode,
                        largeButtonType: .signNext
                    ).padding(.horizontal, 20)
                    
                    LargeButtonView(
                        action: {},
                        title: StringsToken.Sign.DontReceiveCode,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }.padding(.horizontal, 16)
        }
    }

}

#Preview {
    ConfirmCodeScreen(verificationID: "", mobileNumber: "")
}
