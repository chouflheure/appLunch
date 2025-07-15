import PhotosUI
import SwiftUI
import Lottie

struct TeamEditViewScreen: View {
    @ObservedObject var coordinator: Coordinator
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel: TeamEditViewModel
    @Environment(\.dismiss) var dismiss
    @ObservedObject var team: Team
    @State private var toast: Toast? = nil
    @State private var isLoadingUpdate: Bool = false
    
    init(coordinator: Coordinator, team: Team) {
        self.coordinator = coordinator
        self.team = team
        self._viewModel = StateObject(wrappedValue: TeamEditViewModel(team: team, allFriends: coordinator.user?.userFriendsContact))
    }

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    CustomTextField(
                        text: $viewModel.titleTeam,
                        keyBoardType: .default,
                        placeHolder: team.title,
                        textFieldType: .editProfile
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 15)
                    VStack {
                        if viewModel.imageProfile == nil {
                            Button(action: {
                                showPhotoPicker()
                            }) {
                                ModernCachedAsyncImage(
                                    url: team.pictureUrlString,
                                    placeholder: Image(systemName: "photo.fill")
                                )
                            }
                            .clipShape(Circle())
                            .frame(width: 90, height: 90)
                            .padding(.vertical, 16)
                            .padding(.bottom, 16)
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
                            
                        } else {
                            Image(uiImage: viewModel.imageProfile ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.white)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
                                .padding(.vertical, 16)
                                .padding(.bottom, 16)
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
                        }
                    }
                    .frame(height: 100)
                    
                    Divider()
                        .overlay(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(
                                    Array(viewModel.setFriends),
                                    id: \.self
                                ) { user in
                                    CellFriendAdmin(
                                        userPreview: user,
                                        isEditingAdmin: .constant(true),
                                        isAdmin: Binding(
                                            get: {
                                                viewModel.setAdmins
                                                    .contains(user)
                                            },
                                            set: { isAdmin in
                                                if isAdmin {
                                                    viewModel.setAdmins
                                                        .insert(user)
                                                } else {
                                                    viewModel.setAdmins
                                                        .remove(user)
                                                }
                                            }
                                        )
                                    ).padding(.trailing, 12)
                                }
                                .frame(height: 110)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .overlay(.whitePrimary)
                    
                    NavigationLink(destination: {
                        ListFriendToAdd(
                            isPresented: .constant(true),
                            coordinator: coordinator,
                            friendsOnTeam: $viewModel.setFriends,
                            allFriends: $viewModel.allFriends,
                            showArrowDown: false
                        )
                        .customNavigationFlexible(
                            leftElement: {
                                NavigationBackIcon()
                            },
                            centerElement: {
                                Text("Qui dans la team ?")
                                    .tokenFont(.Title_Gigalypse_24)
                            },
                            rightElement: {
                                EmptyView()
                            },
                            hasADivider: true
                        )
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
                    
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            HStack {
                                Image(.iconCross)
                                    .foregroundColor(.white)
                                    .padding(.leading, 15)
                                    .padding(.vertical, 10)
                                
                                Text(StringsToken.General.cancel)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 15)
                                    .padding(.vertical, 10)
                                    .tokenFont(.Body_Inter_Medium_16)
                            }
                        }
                    )
                    .frame(width: 150)
                    .background(.clear)
                    .cornerRadius(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundColor(.white)
                            .background(.clear)
                    }
                    
                    Button(
                        action: {
                            isLoadingUpdate = true
                            viewModel.pushEditTeamToFirebase(uuidTeam: team.uid) { success, message in
                                if success {
                                    isLoadingUpdate = false
                                    dismiss()
                                } else {
                                    isLoadingUpdate = false
                                    toast = Toast(
                                        style: .error,
                                        message: message
                                    )
                                }
                            }
                        },
                        label: {
                            HStack {
                                Image(.iconSend)
                                    .foregroundColor(viewModel.isEnableButton ? .white : .gray)
                                    .padding(.leading, 15)
                                    .padding(.vertical, 10)
                                
                                Text("Modifier")
                                    .foregroundColor(viewModel.isEnableButton ? .white : .gray)
                                    .padding(.trailing, 15)
                                    .padding(.vertical, 10)
                                    .tokenFont(.Body_Inter_Medium_16)
                            }
                        }
                    )
                    .disabled(!viewModel.isEnableButton)
                    .frame(width: 150)
                    .background(Color(hex: "B098E6").opacity(viewModel.isEnableButton ? 1 : 0.5))
                    .cornerRadius(10)
                }
            }
            if isLoadingUpdate {
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
        .blur(radius: isLoadingUpdate ? 10 : 0)
        .allowsHitTesting(!isLoadingUpdate)
        .padding(.vertical, 30)
        .toastView(toast: $toast)
        .customNavigationFlexible(
            leftElement: {
                EmptyView()
            },
            centerElement: {
                Text("Edit ta team")
                    .tokenFont(.Title_Gigalypse_24)
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
