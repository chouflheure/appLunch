
import SwiftUI

struct TitleTurnCardView: View {
    
    // TODO: Change with user
    var userProfileImage: UIImage = .profile
     
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"]
    )

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            
            if viewModel.isEditing {
                CustomTextField(
                    text: $viewModel.title,
                    keyBoardType: .default,
                    placeHolder: StringsToken.TurnCardInformation.PlaceholderTitle,
                    textFieldType: .turn
                )
                .focused($isFocused)
                .padding(.bottom, 16)
                
            } else {

                Text(viewModel.title)
                    .tokenFont(.Title_Inter_semibold_24)
                    .padding(.bottom, 16)
                    .bold()
                    .textCase(.uppercase)
            }

            HStack {
                Image(uiImage: userProfileImage)
                Text(user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)
                
                Spacer()
                    .onTapGesture {
                        print("@@@ here")
                    }
                
                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }
                
                ButtonParticipate(action: {})
            }

            PreviewProfile(pictures: [], previewProfileType: .userComming)
                    .padding(.vertical, 8)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
            .ignoresSafeArea()
        TitleTurnCardView(viewModel: TurnCardViewModel())
    }
}
