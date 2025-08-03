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
                    textFieldType: .sign,
                    characterLimit: 40
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
                    friendsAdd: $viewModel.friendsAdd,
                    allFriends: $viewModel.friendsList,
                    teamToAdd: .constant([]),
                    allTeams: .constant([])
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
