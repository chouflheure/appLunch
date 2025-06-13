import PhotosUI
import SwiftUI

struct TeamEditViewScreen: View {
    @ObservedObject var coordinator: Coordinator
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @ObservedObject var viewModel = TeamEditViewModel()

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        if coordinator.teamDetail != nil {
            viewModel.uuidTeam = coordinator.teamDetail?.uid ?? ""
            viewModel.titleTeam = coordinator.teamDetail?.title ?? ""
            viewModel.pictureUrlString = coordinator.teamDetail?.pictureUrlString ?? ""
            viewModel.setFriends = Set(coordinator.teamDetail?.friendsContact ?? [UserContact()])
            viewModel.setAdmins = Set(coordinator.teamDetail?.adminsContact ?? [UserContact()])
        } else {
            withAnimation {
                coordinator.showTeamDetailEdit = false
            }
        }
    }

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showTeamDetailEdit) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                coordinator.showTeamDetailEdit = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }

                        Spacer()

                        CustomTextField(
                            text: $viewModel.titleTeam,
                            keyBoardType: .default,
                            placeHolder: "Titre team",
                            textFieldType: .sign
                        )
                    }
                    .padding(.horizontal, 16)

                    VStack {
                        if viewModel.imageProfile == nil {
                            Button(action: {
                                showPhotoPicker()
                            }) {
                                CachedAsyncImageView(
                                    urlString: viewModel.pictureUrlString,
                                    designType: .scaleImageTeam
                                )
                            }
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
                        
                        Divider()
                            .overlay(.white)

                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    ForEach(
                                        Array(viewModel.setFriends), id: \.self
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

                    }

                    Spacer()

                    HStack(spacing: 30) {
                        Button(
                            action: {
                                withAnimation {
                                    coordinator.showTeamDetailEdit = false
                                }
                            },
                            label: {
                                HStack {
                                    Image(.iconCross)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))
                                    Text(StringsToken.General.cancel)
                                        .foregroundColor(.white)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 15, weight: .bold))
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
                                withAnimation {
                                    coordinator.showTeamDetailEdit = false
                                }
                                viewModel.pushEditTeamToFirebase(uuidTeam: coordinator.teamDetail?.uid ?? "")
                            },
                            label: {
                                HStack {
                                    Image(.iconSend)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))

                                    Text("Modifier")
                                        .foregroundColor(.white)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 15, weight: .bold))
                                }
                            }
                        )
                        .frame(width: 150)
                        .background(Color(hex: "B098E6"))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showFriendsList) {
            ListFriendToAdd(
                isPresented: $viewModel.showFriendsList,
                coordinator: coordinator,
                friendsOnTeam: $viewModel.setFriends,
                allFriends: $viewModel.allFriends
            )
        }
        .padding(.vertical, 30)
    }

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}
