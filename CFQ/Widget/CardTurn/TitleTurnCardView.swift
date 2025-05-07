import SwiftUI

struct TitleTurnCardPreviewView: View {

    // TODO: Change with user
    var userProfileImage: UIImage = .profile

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: "Ici"
    )
    
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.turn.titleEvent.isEmpty ? "Titre du TURN" : viewModel.turn.titleEvent)
                .tokenFont(.Title_Inter_semibold_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                Image(uiImage: userProfileImage)

                Text(user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

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

struct TitleTurnCardDetailView: View {

    // TODO: Change with user
    var userProfileImage: UIImage = .profile

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: "Ici"
    )

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {

            CustomTextField(
                text: $viewModel.turn.titleEvent,
                keyBoardType: .default,
                placeHolder: StringsToken.TurnCardInformation.PlaceholderTitle,
                textFieldType: .turn
            )
            .focused($isFocused)
            .padding(.bottom, 16)

            HStack {
                Image(uiImage: userProfileImage)

                Text(user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()
                    .onTapGesture {}

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {})
            }

            Button(action: {}) {
                HStack {
                    Image(.iconAddfriend)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)

                    Text("Ajoute tes amis à l'évent")
                        .tokenFont(.Body_Inter_Medium_16)
                }
            }.padding(.vertical, 10)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
            .ignoresSafeArea()
        //    TitleTurnCardView(viewModel: TurnCardViewModel())
    }
}
