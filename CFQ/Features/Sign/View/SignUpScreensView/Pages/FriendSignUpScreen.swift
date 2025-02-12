import SwiftUI

struct FriendSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(Strings.Sign.TitleFindYourFriends)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)

                    CustomTextField(text:   $viewModel.friend, keyBoardType: .default, placeHolder: "Martin", textFieldType: .sign)
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
                    LargeButtonView(
                        action: {viewModel.goNext()},
                        title: Strings.Sign.CheckConfirmCode,
                        largeButtonType: .signNext
                    ).padding(.horizontal, 20)

                    LargeButtonView(
                        action: {viewModel.goBack()},
                        title: Strings.Sign.TtitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
    }

}

#Preview {
    FriendSignUpScreen(viewModel: .init())
}

