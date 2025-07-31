import Lottie
import SwiftUI

struct CFQFormView: View {

    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: CFQFormViewModel
    @State private var toast: Toast? = nil
    @Environment(\.dismiss) var dismiss

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: CFQFormViewModel(coordinator: coordinator)
        )
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                PostEventButton(
                    action: {
                        viewModel.pushCFQ {
                            success,
                            message in
                            if success {
                                dismiss()
                            } else {
                                toast = Toast(
                                    style: .error,
                                    message: message
                                )
                            }
                        }
                    },
                    isEnable: $viewModel.isEnableButton
                )
                .padding(.trailing, 16)
            }
            .padding(.top, 5)
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        HStack(alignment: .center, spacing: 12) {
                            CachedAsyncImageView(
                                urlString: coordinator.user?
                                    .profilePictureUrl ?? "",
                                designType: .scaledToFill_Circle
                            )
                            .frame(width: 50, height: 50)
                            .cornerRadius(100)

                            CustomTextField(
                                text: $viewModel.titleCFQ,
                                keyBoardType: .default,
                                placeHolder: "DEMAIN",
                                textFieldType: .cfq
                            )
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)

                        SearchBarView(
                            text: $viewModel.researchText,
                            placeholder: StringsToken.SearchBar
                                .placeholderFriend,
                            onRemoveText: {
                                viewModel.removeText()
                            },
                            onTapResearch: {
                                viewModel.researche()
                            }
                        )
                        .padding(.top, 16)

                        AddFriendsAndListView(
                            arrayGuest: $viewModel.friendsAddToCFQ,
                            arrayFriends: $viewModel.friendsList,
                            arrayTeamGuest: $viewModel.teamAddToCFQ,
                            arrayTeam: $viewModel.arrayTeam,
                            coordinator: coordinator,
                            onRemove: { userRemoved in
                                viewModel.removeFriendsFromList(
                                    user: userRemoved
                                )
                            },
                            onAdd: { userAdd in
                                viewModel.addFriendsToList(
                                    user: userAdd
                                )
                            },
                            onRemoveTeam: { teamRemove in
                                viewModel.removeTeamFromList(team: teamRemove)
                            },
                            onAddTeam: { teamAdd in
                                viewModel.addTeamToList(team: teamAdd)
                            }
                        )
                        .padding(.top, 15)
                    }
                }
            }
        }
        .blur(radius: viewModel.isLoading ? 10 : 0)
        .allowsHitTesting(!viewModel.isLoading)
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: StringsToken.CFQ.titleCFQ)
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: false
        )
        .toastView(toast: $toast)
        .fullBackground(imageName: StringsToken.Image.fullBackground)

        if viewModel.isLoading {
            ZStack {
                LottieView(
                    animation: .named(
                        StringsToken.Animation.loaderCircle
                    )
                )
                .playing()
                .looping()
                .frame(width: 150, height: 150)
            }
            .zIndex(3)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CFQFormView(coordinator: Coordinator())
    }.ignoresSafeArea()
}

struct CellTeamAdd: View {
    var team: Team
    var onAdd: (() -> Void)

    var body: some View {
        HStack(spacing: 0) {
            CirclePicture(urlStringImage: team.pictureUrlString)
                .frame(width: 48, height: 48)
            HStack {
                Text(team.title)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
                    .lineLimit(1)
                
                Text("- \(team.friends.count) membres")
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            Button(action: {
                onAdd()
            }) {
                Image(.iconPlus)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
        }.padding(.horizontal, 16)
    }
    
}

struct CellFriendsAdd: View {
    var userPreview: UserContact
    var onAdd: (() -> Void)

    var body: some View {
        HStack(spacing: 0) {
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
                Image(.iconPlus)
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 30)
        }.padding(.horizontal, 16)
    }
}
