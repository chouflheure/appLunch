
import SwiftUI
import PhotosUI

struct TeamFormView: View {
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @State private var text = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("NOUVELLE TEAM")
                    .foregroundColor(.white)
                    .padding(.leading, 40)
                    .font(.custom("GigalypseTrial-Regular", size: 24))
                    .frame(maxWidth: .infinity, alignment: .center)

                Button(action: {print("@@@ close button click")}) {
                    Image(.iconCross)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                }
            }
            .padding(.top, 70)
            
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
            .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
            .task(id: avatarPhotoItem) {
                if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }

            TextFieldBGBlackFull(text: $text, keyBoardType: .default, placeHolder: "test")
                .padding(.horizontal, 16)

            Bazar()
            
            FullButtonLogIn(
                action: {},
                title: "Créer la team",
                largeButtonType: .teamCreate
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 30)

        }
    }
    
    private func showPhotoPicker() {
        print("@@@ click photo")
        isPhotoPickerPresented = true
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamFormView()
    }.ignoresSafeArea()
}
