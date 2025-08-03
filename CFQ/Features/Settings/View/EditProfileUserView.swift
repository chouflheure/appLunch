import PhotosUI
import SwiftUI

struct EditProfileUserView: View {
    @Binding var showDetail: Bool

    @EnvironmentObject var user: User
    @StateObject private var viewModel: EditProfileViewModel

    init(showDetail: Binding<Bool>, user: User) {
        _showDetail = showDetail
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }

    var body: some View {
        DraggableViewLeft(isPresented: $showDetail) {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                showDetail = false
                            }
                        },
                        titleScreen: "Mon Profil"
                    )

                    VStack(spacing: 20) {
                        ScrollView {
                            Button(action: {
                                viewModel.showPhotoPicker()
                            }) {
                                Circle()
                                    .frame(width: 150, height: 150)
                                    .foregroundColor(.black)
                                    .overlay(
                                        ZStack(alignment: .bottom) {
                                            if let selectedImage = viewModel.selectedImage
                                            {
                                                Image(uiImage: selectedImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .clipShape(Circle())
                                                    .frame(
                                                        width: 150, height: 150)
                                            } else {
                                                Circle()
                                                    .stroke(
                                                        style: StrokeStyle(
                                                            lineWidth: 0.5)
                                                    )
                                                    .foregroundColor(.white)

                                                Image(systemName: "photo")
                                                    .foregroundColor(.white)
                                                    .scaleEffect(CGFloat(2))
                                                    .padding(.bottom, 30)
                                            }
                                        }
                                    )
                            }

                            CustomTextField(
                                text: $viewModel.pseudo,
                                keyBoardType: .default,
                                placeHolder: user.pseudo,
                                textFieldType: .editProfile,
                                characterLimit: 40
                            )

                            CustomTextField(
                                text: $viewModel.name,
                                keyBoardType: .default,
                                placeHolder: user.name,
                                textFieldType: .editProfile,
                                characterLimit: 40
                            )

                            CollectionViewLocalisations(
                                selectedItem: $viewModel.localisation
                            )
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 16)

                        LargeButtonView(
                            action: {
                                viewModel.editProfileOnDB(userUUID: user.uid)
                            },
                            title: StringsToken.Settings.edit,
                            largeButtonType: .settings
                        )
                        .padding(.bottom, 50)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 50)
                .photosPicker(
                    isPresented: $viewModel.isPhotoPickerPresented,
                    selection: $viewModel.avatarPhotoItem, matching: .images
                )
                .task(id: viewModel.avatarPhotoItem) {
                    if let data = try? await viewModel.avatarPhotoItem?.loadTransferable(
                        type: Data.self),
                        let uiImage = UIImage(data: data)
                    {
                        viewModel.selectedImage = uiImage
                    }
                }

            }
        }
        .onAppear() {
            viewModel.localisation = user.location
        }
    }
}
