import PhotosUI
import SwiftUI

struct TeamFormView: View {
    // @Binding var showDetail: Bool
    @ObservedObject var coordinator: Coordinator
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel = TeamFormViewModel()

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showCreateTeam) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                coordinator.showCreateTeam = false
                                // showDetail = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                        }

                        Spacer()

                        Text("NOUVELLE TEAM")
                            .tokenFont(.Title_Gigalypse_24)

                        Spacer()

                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 25)
                    .zIndex(100)

                    ZStack(alignment: .bottom) {
                        if let selectedImage = viewModel.imageProfile {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
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
                    .onTapGesture {
                        showPhotoPicker()
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
                            viewModel.imageProfile = Image(uiImage: uiImage)
                        }
                    }

                    CustomTextField(
                        text: $viewModel.nameTeam,
                        keyBoardType: .default,
                        placeHolder: "test",
                        textFieldType: .sign
                    )
                    .padding(.horizontal, 16)

                    Button(action: {
                        viewModel.showFriendsList = true
                    }) {
                        Text("Ajouter des amis")
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                    .padding()
                    .overlay() {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.white, lineWidth: 1)
                    }
                    .padding(.top, 15)

                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack {
                            HStack {
                                ForEach(Array(viewModel.friendsAdd), id: \.self) { user in
                                /*    CellPictureCanRemove(name: user.name) {
                                        viewModel.removeFriendsFromList(user: user)
                                    }
                                 */
                                }.frame(height: 100)
                            }
                        }
                    }
                    .padding(.top, 15)

                    Spacer()

                    LargeButtonView(
                        action: {
                            viewModel.pushNewTeamToFirebase()
                        },
                        title: "Créer la team",
                        largeButtonType: .teamCreate,
                        isDisabled: viewModel.friendsAdd.isEmpty ||
                            viewModel.nameTeam.isEmpty ||
                            viewModel.imageProfile == nil
                    )
                    .padding(.horizontal, 16)
                    
                }
            }
            /*
            .fullScreenCover(isPresented: $viewModel.showFriendsList) {
                ListFriendToAdd(
                    isPresented: $viewModel.showFriendsList,
                    coordinator: coordinator
                )
            }
             */
            .padding(.top, 30)
            .padding(.bottom, 30)
        }
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

    init(coordinator: Coordinator, friendsOnTeam: Binding<Set<UserContact>>, allFriends: Binding<Set<UserContact>>) {
        self.coordinator = coordinator
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
        sortListFriendOnTeam()
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
                name.name.lowercased().hasPrefix(word)
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

    // @Binding var allfriends: Set<UserContact>

    init(isPresented: Binding<Bool>, coordinator: Coordinator, friendsOnTeam: Binding<Set<UserContact>>, allFriends: Binding<Set<UserContact>>) {
        self._isPresented = isPresented
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: ListFriendToAddViewModel(coordinator: coordinator, friendsOnTeam: friendsOnTeam, allFriends: allFriends))
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
    }

    var body: some View {
        SafeAreaContainer {
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
                .padding(.horizontal, 16)
                .padding(.top, 50)
                .zIndex(100)
/*
                AddFriendsAndListView(
                    arrayPicture: $friendsOnTeam,
                    arrayFriends: $viewModel.userFriends,
                    onRemove: { userRemoved in
                        viewModel.removeFriendsFromList(user: userRemoved)
                    },
                    onAdd: { userAdd in
                        viewModel.addFriendsToList(user: userAdd)
                    }
                )
 */
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        // TeamFormView(showDetail: .constant(true))
    }.ignoresSafeArea()
}
