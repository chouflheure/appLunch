import PhotosUI
import SwiftUI
import Lottie

struct TeamFormView: View {

    @ObservedObject var coordinator: Coordinator
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel: TeamFormViewModel
    @Environment(\.dismiss) var dismiss
    @State private var toast: Toast? = nil

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: TeamFormViewModel(coordinator: coordinator)
        )
    }

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottom) {
                    if let selectedImage = viewModel.imageProfile {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        ZStack {
                            Circle()
                                .foregroundColor(.blackSurface)
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .scaleEffect(CGFloat(2))
                        }
                    }
                }
                .padding(.vertical, 32)
                .contentShape(Circle())
                .onTapGesture {
                    isPhotoPickerPresented = true
                }
                .photosPicker(
                    isPresented: $isPhotoPickerPresented,
                    selection: $avatarPhotoItem,
                    matching: .images
                )
                .task(id: avatarPhotoItem) {
                    if let data = try? await avatarPhotoItem?
                        .loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data)
                    {
                        viewModel.imageProfile = uiImage
                    }
                }
                
                CustomTextField(
                    text: $viewModel.nameTeam,
                    keyBoardType: .default,
                    placeHolder: "Nom de ta team",
                    textFieldType: .sign
                )
                .padding(.horizontal, 16)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack {
                        HStack {
                            ForEach(Array(viewModel.friendsAdd), id: \.self) {
                                friend in
                                NavigationLink(
                                    destination: FriendProfileView(
                                        coordinator: coordinator,
                                        user: coordinator.user ?? User(),
                                        friend: friend
                                    )
                                ) {
                                    CellFriendCanRemove(userPreview: friend) {
                                        viewModel.removeFriendsFromList(
                                            user: friend
                                        )
                                    }
                                }
                            }.frame(height: 100)
                        }
                    }
                }
                .padding(.top, 15)
                
                Button(action: {
                    viewModel.showFriendsList = true
                }) {
                    Text("Ajouter des amis")
                        .tokenFont(.Body_Inter_Medium_16)
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.white, lineWidth: 1)
                }
                .padding(.top, 15)
                
                Spacer()
                
                LargeButtonView(
                    action: {
                        viewModel.pushNewTeamToFirebase { success, message in
                            if success {
                                dismiss()
                                // coordinator.selectedTab = 0
                            } else {
                                toast = Toast(
                                    style: .error,
                                    message: message
                                )
                            }
                            viewModel.isLoading = false
                        }
                    },
                    title: "Créer la team",
                    largeButtonType: .teamCreate,
                    isDisabled: viewModel.friendsAdd.isEmpty
                    || viewModel.nameTeam.isEmpty
                    || viewModel.imageProfile == nil
                )
                .padding(.horizontal, 16)
                
            }
            
            if viewModel.isLoading {
                ZStack {
                    LottieView(
                        animation: .named(StringsToken.Animation.loaderCircle)
                    )
                    .playing()
                    .looping()
                    .frame(width: 150, height: 150)
                }
                .zIndex(3)
            }

        }
        .blur(radius: viewModel.isLoading ? 10 : 0)
        .allowsHitTesting(!viewModel.isLoading)
        .toastView(toast: $toast)
        .fullScreenCover(isPresented: $viewModel.showFriendsList) {
            NavigationView {
                ListFriendToAdd(
                    isPresented: $viewModel.showFriendsList,
                    coordinator: coordinator,
                    friendsOnTeam: $viewModel.friendsAdd,
                    allFriends: $viewModel.friendsList
                )
            }
        }
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: StringsToken.Team.newTeam)
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: false
        )

    }

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}

class ListFriendToAddViewModel: ObservableObject {
    // @Published var friendsOnTeam = Set<UserContact>()

    @Published var coordinator: Coordinator
    @Published var researchText = ""
    // @Published var userFriends = Set<UserContact>()
    @Binding var friendsOnTeam: Set<UserContact>
    @Binding var allFriends: Set<UserContact>
    private var allFriendstemps = Set<UserContact>()

    init(
        coordinator: Coordinator,
        friendsOnTeam: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>
    ) {
        self.coordinator = coordinator
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
        // sortListFriendOnTeam()
        allFriendstemps = friendsOnTeam.wrappedValue
    }

    func sortListFriendOnTeam() {
        /*
        if let friendsOnTeamFromCoordinator = coordinator.teamDetail?.friends {
            friendsOnTeam = Set(friendsOnTeamFromCoordinator)
        }
        
         */
        // friendsOnTeam = friends
        allFriends = allFriends.filter { !friendsOnTeam.contains($0) }
    }

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriendstemps.filter { name in
            searchWords.allSatisfy { word in
                name.pseudo.lowercased().hasPrefix(word)
                    || name.name.lowercased().hasPrefix(word)
            }
        }
    }

    func removeFriendsFromList(user: UserContact) {
        friendsOnTeam.remove(user)
        allFriends.insert(user)
        allFriendstemps.insert(user)
    }

    func addFriendsToList(user: UserContact) {
        friendsOnTeam.insert(user)
        allFriends.remove(user)
        allFriendstemps.remove(user)
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        allFriends = allFriendstemps
        allFriends = filteredNames
    }
}

struct ListFriendToAdd: View {
    @Binding var isPresented: Bool
    @ObservedObject var coordinator: Coordinator
    @StateObject private var viewModel: ListFriendToAddViewModel
    @Binding var friendsOnTeam: Set<UserContact>
    @Binding var allFriends: Set<UserContact>
    var showArrowDown: Bool

    init(
        isPresented: Binding<Bool>,
        coordinator: Coordinator,
        friendsOnTeam: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>,
        showArrowDown: Bool = true
    ) {
        self._isPresented = isPresented
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: ListFriendToAddViewModel(
                coordinator: coordinator,
                friendsOnTeam: friendsOnTeam,
                allFriends: allFriends
            )
        )
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
        self.showArrowDown = showArrowDown
    }

    var body: some View {
        VStack {
            HStack {
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

                Spacer()
                if showArrowDown {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(.iconArrow)
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .rotationEffect(Angle(degrees: -90))
                    }
                }
            }
            .padding(.horizontal, 16)

            AddFriendsAndListView(
                arrayPicture: viewModel.$friendsOnTeam,
                arrayFriends: viewModel.$allFriends,
                coordinator: coordinator,
                onRemove: { userRemoved in
                    viewModel.removeFriendsFromList(user: userRemoved)
                },
                onAdd: { userAdd in
                    viewModel.addFriendsToList(user: userAdd)
                }
            )
            .padding(.top, 30)
        }
    }
}
