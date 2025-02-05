import SwiftUI
import PhotosUI

struct PictureSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    var body: some View {
        ZStack {
            NeonBackgroundImage()

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.vertical, 50)

                VStack {
                    Text(Strings.Login.TitleAddPicture)
                        .foregroundColor(.white)
                        .font(.title)
                        .textCase(.uppercase)
                        .padding(.bottom, 50)
                    
                    Button(action: {}) {
                        Circle()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.black)
                            .overlay(
                                ZStack(alignment: .bottom) {
                                    if let selectedImage = selectedImage {
                                        selectedImage
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 150, height: 150)
                                    } else {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 0.5))
                                            .foregroundColor(.white)

                                        Image(systemName: "photo")
                                            .foregroundColor(.white)
                                            .scaleEffect(CGFloat(2))
                                            .padding(.bottom, 30)
                                    }
                                }
                            )
                            .onTapGesture {
                                showPhotoPicker()
                            }
                    }
                }

                Spacer()

                VStack {
                    FullButtonLogIn(
                        action: {viewModel.goNext()},
                        title: Strings.Login.CheckConfirmCode,
                        color: .blackMain
                    ).padding(.horizontal, 20)

                    PurpleButtonLogIn(
                        action: {viewModel.goBack()},
                        title: Strings.Login.TtitleBackStep
                    )}
                .padding(.bottom, 100)
            }
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
            .task(id: avatarPhotoItem) {
                if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }

    @State private var isPhotoPickerPresented = false

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
}

#Preview {
    PictureSignUpScreen(viewModel: .init())
}
