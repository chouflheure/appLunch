import PhotosUI
import SwiftUI

struct TeamEditViewScreen: View {
    @Binding var show: Bool
    @ObservedObject var coordinator: Coordinator
    @State var text: String = ""
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @StateObject var viewModel = TeamEditViewModel()
    @StateObject var viewModel2 = TeamFormViewModel()
    
    var edit = false

    init(show: Binding<Bool>, coordinator: Coordinator) {
        self._show = show
        self._coordinator = ObservedObject(initialValue: coordinator)
        self._viewModel = StateObject(wrappedValue: TeamEditViewModel())
        self.text = coordinator.teamDetail?.title ?? ""
    }
    
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

    var body: some View {
        DraggableViewLeft(isPresented: $show) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                show = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }

                        Spacer()

                        CustomTextField(
                            text: $viewModel.nameTeam,
                            keyBoardType: .default,
                            placeHolder: coordinator.teamDetail?.title ?? "",
                            textFieldType: .editProfile
                        )
                    }
                    .padding(.horizontal, 16)

                    VStack {
                        Button(action: {
                            showPhotoPicker()
                        }) {

                            Image(.header)
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.white)
                                .frame(width: 90, height: 90)
                                .clipShape(Circle())
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
                                viewModel.imageProfile = Image(uiImage: uiImage)
                            }
                        }
                        Divider()
                            .overlay(.white)

                        ScrollView(.horizontal, showsIndicators: false) {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    ForEach(
                                        Array(viewModel.friendsAdd), id: \.self
                                    ) { user in
                                        CellFriendAdmin(
                                            name: user.name,
                                            isEditingAdmin: .constant(true),
                                            isAdmin: Binding(
                                                get: {
                                                    viewModel.adminList
                                                        .contains(user)
                                                },
                                                set: { newValue in
                                                    if newValue {
                                                        viewModel.adminList
                                                            .insert(user)
                                                    } else {
                                                        viewModel.adminList
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
                                    show = false
                                }
                            },
                            label: {
                                HStack {
                                    Image(.iconCross)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))
                                    Text("Annuler")
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
                                viewModel.uuidTeam = coordinator.teamDetail?.uid ?? ""
                                viewModel.pushEditTeamToFirebase()
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
                showDetail: $viewModel.showFriendsList,
                viewModel: viewModel2
            )
        }
        .padding(.top, 30)
        .padding(.bottom, 30)
    }

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamEditViewScreen(show: .constant(true), coordinator: Coordinator())
    }.ignoresSafeArea()
}
