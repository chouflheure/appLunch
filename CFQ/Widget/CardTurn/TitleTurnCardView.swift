import SwiftUI

struct TitleTurnCardPreviewView: View {
    
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleEvent.isEmpty ? StringsToken.Turn.placeholderTitleEvent : viewModel.titleEvent)
                .tokenFont(viewModel.titleEvent.isEmpty ? .Placeholder_Gigalypse_24 : .Title_Gigalypse_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                CachedAsyncImageView(urlString: viewModel.user.profilePictureUrl, designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(viewModel.user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .textCase(.lowercase)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))
            }
        }
    }
}

struct TitleTurnCardDetailView: View {

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel
    @State var showFriendProfile: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            CustomTextField(
                text: $viewModel.titleEvent,
                keyBoardType: .default,
                placeHolder: "LE TITRE",
                textFieldType: .turn
            )
            .tokenFont(.Title_Gigalypse_24)
            .padding(.bottom, 16)

            HStack {
                CachedAsyncImageView(urlString: viewModel.user.profilePictureUrl, designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(viewModel.user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))

            }
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
