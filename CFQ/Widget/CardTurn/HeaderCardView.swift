
import SwiftUI
import PhotosUI

struct HeaderCardView: View {
    @StateObject var viewModel: TurnCardViewModel
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    var isPreviewCard: Bool

    var body: some View {
        ZStack() {
            ZStack(alignment: .bottom) {
                if let selectedImage = selectedImage {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(height: isPreviewCard ? 100 : 200)
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

                if(isPreviewCard) {
                    Text("Turn")
                        .tokenFont(.Title_Gigalypse_24)
                        .bold()
                        .textCase(.uppercase)
                        .font(.system(size: 30))
                } else {
                    Button(action: {
                        withAnimation {
                            viewModel.showDetailTurnCard = false
                        }
                    }) {
                        Image(.iconCross)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
        .task(id: avatarPhotoItem) {
            if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = Image(uiImage: uiImage)
            }
        }
        
    }

    private func showPhotoPicker() {
        Logger.log("Click on photo picker", level: .action)
        if viewModel.isEditing {
            isPhotoPickerPresented = true
        }
    }
}

