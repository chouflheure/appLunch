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
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))
            }
            
            Text(StringsToken.Turn.noParticipantsYet)
                .tokenFont(.Body_Inter_Medium_14)
                .padding(.vertical, 8)
        }
    }
}

struct TitleTurnCardDetailView: View {

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel
    @ObservedObject var coordinator: Coordinator
    
    @State var showFriendProfile: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            TextField("title event", text: $viewModel.titleEvent)
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
                CachedAsyncImageView(urlString: viewModel.user.profilePictureUrl, designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(viewModel.user.pseudo)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {}, selectedOption: .constant(.yes))

            }

            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    HStack {
                        ForEach(Array(viewModel.setFriendsOnTurn), id: \.self) { user in
                            CellFriendCanRemove(userPreview: user) {
                                viewModel.removeFriendsFromList(
                                    user: user
                                )
                            }
                            .onTapGesture {
                                showFriendProfile = true
                                
                                coordinator.profileUserSelected = User(
                                    uid: user.uid,
                                    name: user.name,
                                    firstName: user.firstName,
                                    pseudo: user.pseudo,
                                    profilePictureUrl: user
                                        .profilePictureUrl,
                                    isActive: user.isActive
                                )
                                
                            }
                        }.frame(height: 100)
                    }
                }
            }
            .padding(.top, 15)
            
            Button(action: {
                viewModel.showFriendsList = true
            }) {
                HStack {
                    Image(.iconAddfriend)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)

                    Text(StringsToken.Turn.addYourFriendToTheEvent)
                        .tokenFont(.Body_Inter_Medium_16)
                }
            }.padding(.vertical, 10)
        }
        .fullScreenCover(isPresented: $viewModel.showFriendsList) {
            ListFriendToAdd(
                isPresented: $viewModel.showFriendsList,
                coordinator: viewModel.coordinator,
                friendsOnTeam: $viewModel.setFriendsOnTurn,
                allFriends: $viewModel.friendListToAdd
            )
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
