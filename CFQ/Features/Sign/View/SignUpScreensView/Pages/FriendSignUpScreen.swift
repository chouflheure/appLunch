import SwiftUI

struct FriendSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel

    var body: some View {
        ZStack {
            Image(.backgroundNeon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(Strings.Login.TitleFindYourFriends)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    TextFieldBGBlackFull(text: $viewModel.friend, keyBoardType: .default, placeHolder: "Martin")
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    Button(action: viewModel.addFriend, label: {
                        Text("Add Friends")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.black)
                            .cornerRadius(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.white, lineWidth: 0.5)
                            )
                            
                    })
                }

                Spacer()

                VStack {
                    FullButtonLogIn(
                        action: {viewModel.goNext()},
                        title: Strings.Login.CheckConfirmCode
                    ).padding(.horizontal, 20)

                    PurpleButtonLogIn(
                        action: {viewModel.goBack()},
                        title: Strings.Login.TtitleBackStep
                    )}
                .padding(.bottom, 100)
            }
        }
    }

}

#Preview {
    FriendSignUpScreen(viewModel: .init())
}

