import SwiftUI
import PhotosUI

struct PictureSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var body: some View {
        SafeAreaContainer {

            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.bottom, 30)

                VStack {
                    Text(StringsToken.Sign.TitleAddPicture)
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
                                        Image(uiImage: selectedImage)
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
                    LargeButtonView(
                        action: {
                            viewModel.picture = selectedImage ?? UIImage()
                            viewModel.goNext()
                        },
                        title: StringsToken.Sign.Next,
                        largeButtonType: .signNext,
                        isDisabled: selectedImage == nil
                    ).padding(.horizontal, 20)
                    
                    LargeButtonView(
                        action: {viewModel.goBack()},
                        title: StringsToken.Sign.TitleBackStep,
                        largeButtonType: .signBack
                    ).padding(.horizontal, 20)
                }
            }
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
            .task(id: avatarPhotoItem) {
                if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
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
    PictureSignUpScreen(viewModel: .init(uidUser: ""))
}
