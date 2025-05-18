import SwiftUI

struct TitleTurnCardPreviewView: View {
    
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.turn.titleEvent.isEmpty ? "Titre du TURN" : viewModel.turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                CachedAsyncImageView(urlString: viewModel.adminUser.profilePictureUrl, designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(viewModel.adminUser.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))
            }
            
            Text("0 Personne y va pour l'instant")
                .tokenFont(.Body_Inter_Medium_14)
                .padding(.vertical, 8)
        }
    }
}

struct TitleTurnCardDetailView: View {

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $viewModel.titleEvent)
                .focused($isFocused)
                .padding(.bottom, 16)
            /*
            CustomTextField(
                text: $viewModel.turn.titleEvent,
                keyBoardType: .default,
                placeHolder: StringsToken.TurnCardInformation.PlaceholderTitle,
                textFieldType: .turn
            )
            .focused($isFocused)
            .padding(.bottom, 16)
*/
            HStack {
                CachedAsyncImageView(urlString: viewModel.adminUser.profilePictureUrl, designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(viewModel.adminUser.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()
                    .onTapGesture {}

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))

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
