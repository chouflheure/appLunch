
import SwiftUI

struct ConfirmationScreenDestination: Hashable {}

struct ConfirmCodeScreen: View {
    @State private var text: String = ""
    @State private var hasAlreadyAccount = true
    
    var body: some View {
        ZStack {
            Image(.backgroundNeon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack {
                Image(.logoWhite)
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
                        text: $text,
                        keyBoardType: .phonePad,
                        placeHolder: Strings.Login.PlaceholderConfimCode
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.top, 50)

                Spacer()

                VStack {
                    FullButtonLogIn(
                        action: {},
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
    ConfirmCodeScreen()
}
