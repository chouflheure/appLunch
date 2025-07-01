import PhotosUI
import SwiftUI

struct HeaderCardViewDetail: View {
    @ObservedObject var viewModel: TurnCardViewModel
    @State private var selectedImage: UIImage?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var showPickerStartEvent = false
    
    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .bottom) {
                    if let selectedImage = viewModel.imageSelected {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(width: UIScreen.main.bounds.width)
                            .contentShape(Rectangle())
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
                    VStack {
                        if viewModel.textFormattedShortFormat().jour.isEmpty || viewModel.textFormattedShortFormat().mois.isEmpty {
                            VStack {
                                Image(.iconDate)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                            }
                            .frame(width: 50, height: 55)
                            .background(.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .padding(.top, 20)
                        } else {
                            DateLabel(
                                dayEventString: viewModel.textFormattedShortFormat().jour.isEmpty ? "XX" : viewModel.textFormattedShortFormat().jour,
                                monthEventString: viewModel.textFormattedShortFormat().mois.isEmpty ? "XX" : viewModel.textFormattedShortFormat().mois
                            ).padding(.top, 20)
                        }
                    }.onTapGesture {
                        showPickerStartEvent = true
                    }
                    .sheet(isPresented: $showPickerStartEvent) {
                        ZStack {
                            NeonBackgroundImage()
                            SheetDatePicker(dateEvent: $viewModel.dateEventStart, hoursEvent: $viewModel.startHours, onClose: {
                                showPickerStartEvent = false
                            })
                        }
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(500)])
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            viewModel.showDetailTurnCard = false
                        }
                    }) {
                        Text("Enregistrer")
                            .tokenFont(.Body_Inter_Medium_14)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(width: 80)
                    .background(Color(hex: "B098E6").opacity(1))
                    .cornerRadius(10)
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
                    viewModel.imageSelected = uiImage
                }
            }
        }
    }
}

struct HeaderCardPreviewView: View {
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                if let selectedImage = viewModel.imageSelected {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .clipped()
                }

                HStack(alignment: .center) {
                    if viewModel.textFormattedShortFormat().jour.isEmpty || viewModel.textFormattedShortFormat().mois.isEmpty {
                        VStack {
                            Image(.iconDate)
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                        .frame(width: 50, height: 55)
                        .background(.black.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.top, 20)
                    } else {
                        DateLabel(
                            dayEventString: viewModel.textFormattedShortFormat().jour.isEmpty ? "XX" : viewModel.textFormattedShortFormat().jour,
                            monthEventString: viewModel.textFormattedShortFormat().mois.isEmpty ? "XX" : viewModel.textFormattedShortFormat().mois
                        ).padding(.top, 20)
                    }
                    Spacer()

                    Text("Turn")
                        .tokenFont(.Title_Gigalypse_24)
                        .bold()
                        .textCase(.uppercase)
                        .font(.system(size: 30))
                    
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 150)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        // HeaderCardViewDetail(viewModel: TurnCardViewModel())
    }
}
