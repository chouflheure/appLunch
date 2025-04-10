import PhotosUI
import SwiftUI

struct TeamFormView: View {
    @Binding var showDetail: Bool
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel = TeamFormViewModel()

    var body: some View {
        DraggableView(isPresented: $showDetail) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                showDetail = false
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
                        if let selectedImage = selectedImage {
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
                            selectedImage = Image(uiImage: uiImage)
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
                            print("@@@ \(viewModel.nameTeam)")
                            print("@@@ \(viewModel.friendsAdd)")
                            print("@@@ \(viewModel.friendsList)")
                        },
                        title: "Créer la team",
                        largeButtonType: .teamCreate,
                        isDisabled: viewModel.friendsAdd.isEmpty || viewModel.nameTeam.isEmpty
                    )
                    .padding(.horizontal, 16)
                    
                }
            }
            .fullScreenCover(isPresented: $viewModel.showFriendsList) {
                ListFriendToAdd(
                    showDetail: $viewModel.showFriendsList,
                    viewModel: viewModel
                )
            }
            .padding(.top, 30)
            .padding(.bottom, 30)
        }
    }

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}

struct ListFriendToAdd: View {
    @Binding var showDetail: Bool
    @ObservedObject var viewModel: TeamFormViewModel

    var body: some View {
        SafeAreaContainer {
            VStack {
                HStack {
                    SearchBarView(
                        text: $viewModel.researchText,
                        onRemoveText: {
                            viewModel.removeText()
                        },
                        onTapResearch: {
                            viewModel.researche()
                        }
                    )
                    
                    Button(action: {
                        showDetail = false
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

                AddFriendsAndListView(
                    arrayPicture: $viewModel.friendsAdd,
                    arrayFriends: $viewModel.friendsList,
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
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamFormView(showDetail: .constant(true))
    }.ignoresSafeArea()
}
