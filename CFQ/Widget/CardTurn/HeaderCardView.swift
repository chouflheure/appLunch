
import SwiftUI
import PhotosUI

struct HeaderCardView: View {
    @StateObject var viewModel: TurnCardViewModel
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?

    var body: some View {
        ZStack() {
            ZStack(alignment: .bottom) {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .scaleEffect(CGFloat(2))
                }
            }
            .onTapGesture {
                showPhotoPicker()
            }

            HStack(alignment: .center) {
                DateLabel(
                    dayEventString: viewModel.textFormattedShortFormat().jour,
                    monthEventString: viewModel.textFormattedShortFormat().mois
                ).padding(.top, 20)

                Spacer()

                Text("Turn")
                    .foregroundColor(.white)
                    .bold()
                    .textCase(.uppercase)
                    .font(.system(size: 30))
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 100)
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
        .task(id: avatarPhotoItem) {
            if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
    }

    @State private var isPhotoPickerPresented = false

    private func showPhotoPicker() {
        print("@@@ click photo")
        if viewModel.isEditing {
            isPhotoPickerPresented = true
        }
    }
}

