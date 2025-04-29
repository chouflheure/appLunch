import PhotosUI
import SwiftUI

struct HeaderCardViewDetail: View {
    @ObservedObject var viewModel: TurnCardViewModel
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?

    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .bottom) {
                    if let selectedImage = viewModel.imageSelected {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .contentShape(Rectangle())
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.white)
                            .scaleEffect(CGFloat(2))
                    }
                }
                .onTapGesture {
                    viewModel.showPhotoPicker()
                }

                HStack(alignment: .center) {
                    DateLabel(
                        dayEventString: viewModel.textFormattedShortFormat().jour.isEmpty ? "XX" : viewModel.textFormattedShortFormat().jour,
                        monthEventString: viewModel.textFormattedShortFormat().mois.isEmpty ? "XX" : viewModel.textFormattedShortFormat().mois
                    ).padding(.top, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.showDetailTurnCard = false
                        }
                    }) {
                        Image(.iconArrow)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .rotationEffect(Angle(degrees: -90))
                    }
                    .frame(width: 50, height: 50)
                }
                .padding(.horizontal, 16)
            }
            .photosPicker(
                isPresented: $viewModel.isPhotoPickerPresented,
                selection: $avatarPhotoItem,
                matching: .images
            )
            .task(id: avatarPhotoItem) {
                if let data = try? await avatarPhotoItem?.loadTransferable(
                    type: Data.self),
                   let uiImage = UIImage(data: data)
                {
                    viewModel.imageSelected = Image(uiImage: uiImage)
                }
            }
        }
    }
}

struct HeaderCardPreviewView: View {
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack {
            ZStack {
                if let selectedImage = viewModel.imageSelected {
                    selectedImage
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                }
                
                HStack(alignment: .center) {
                    DateLabel(
                        dayEventString: viewModel.textFormattedShortFormat().jour.isEmpty ? "XX" : viewModel.textFormattedShortFormat().jour,
                        monthEventString: viewModel.textFormattedShortFormat().mois.isEmpty ? "XX" : viewModel.textFormattedShortFormat().mois
                    ).padding(.top, 20)
                    
                    Spacer()
           
                    Text("Turn")
                        .tokenFont(.Title_Gigalypse_24)
                        .bold()
                        .textCase(.uppercase)
                        .font(.system(size: 30))
                    
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        HeaderCardViewDetail(viewModel: TurnCardViewModel())
    }
}
