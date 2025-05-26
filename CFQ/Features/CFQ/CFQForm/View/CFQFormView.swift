
import SwiftUI
import Lottie

struct CFQFormView: View {

    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: CFQFormViewModel

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: CFQFormViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showCFQForm) {
            SafeAreaContainer {
                if viewModel.isLoading {
                    ZStack {
                        LottieView(animation: .named(StringsToken.Animation.loaderCircle))
                            .playing()
                            .looping()
                            .frame(width: 150, height: 150)
                    }
                    .zIndex(3)
                } else {
                    VStack(alignment: .leading) {
                        HeaderBackLeftScreen(
                            onClickBack: {
                                withAnimation {
                                    coordinator.showCFQForm = false
                                }
                            },
                            titleScreen: "CFQ ?"
                        )

                        VStack {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack {
                                    HStack(alignment: .center, spacing: 12) {
                                        CachedAsyncImageView(urlString: coordinator.user?.profilePictureUrl ?? "", designType: .scaledToFill_Circle)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(100)
                                        
                                        CustomTextField(
                                            text: $viewModel.titleCFQ,
                                            keyBoardType: .default,
                                            placeHolder: "Demain",
                                            textFieldType: .cfq
                                        )
                                    }
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    
                                    HStack {
                                        Spacer()
                                        PostEventButton(
                                            action: { viewModel.pushCFQ() },
                                            isEnable: $viewModel.isEnableButton
                                        )
                                        .padding(.trailing, 16)
                                    }
                                    .padding(.top, 5)
                                    
                                    SearchBarView(
                                        text: $viewModel.researchText,
                                        placeholder: StringsToken.SearchBar.placeholderFriend,
                                        onRemoveText: {
                                            viewModel.removeText()
                                        },
                                        onTapResearch: {
                                            viewModel.researche()
                                        }
                                    )
                                    .padding(.top, 16)
                                    
                                    AddFriendsAndListView(
                                        arrayPicture: $viewModel.friendsAddToCFQ,
                                        arrayFriends: $viewModel.friendsList,
                                        coordinator: coordinator,
                                        onRemove: { userRemoved in
                                            viewModel.removeFriendsFromList(user: userRemoved)
                                        },
                                        onAdd: { userAdd in
                                            viewModel.addFriendsToList(user: userAdd)
                                        }
                                    )
                                    .padding(.top, 15)
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CFQFormView(coordinator: Coordinator())
    }.ignoresSafeArea()
}


struct CellFriendsAdd: View {
    // var name: String
    var userPreview: UserContact
    var onAdd: (() -> Void)

    var body: some View {
        HStack(spacing: 0){
            CirclePicture(urlStringImage: userPreview.profilePictureUrl)
                .frame(width: 48, height: 48)
            HStack {
                Text(userPreview.pseudo)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: {
                onAdd()
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.purpleText)
                    .frame(width: 24, height: 24)
            }
        }.padding(.horizontal, 16)
    }
}

/*
struct CellTeamAdd: View {
    var name: String
    var teamNumber: Int

    var body: some View {
        HStack(spacing: 0){
            CirclePicture()
                .frame(width: 48, height: 48)
            HStack {
                Text(name)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
                Text("-")
                    .foregroundColor(.white)
                Text("\(teamNumber) membres")
                    .foregroundColor(.whiteSecondary)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundColor(.purpleText)
                    .frame(width: 24, height: 24)
            }
        }.padding(.horizontal, 16)
    }
}
*/

#Preview {
    ZStack {
        NeonBackgroundImage()
        // CellFriendsAdd()
    }.ignoresSafeArea()
}
