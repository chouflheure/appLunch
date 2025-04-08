import PhotosUI
import SwiftUI

struct TeamFormView: View {
    @Binding var showDetail: Bool
    @State private var selectedImage: Image?
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var isPhotoPickerPresented = false
    @State private var text = ""
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        DraggableView(isPresented: $showDetail) {
            SafeAreaContainer {
                VStack {
                    HStack{
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
                    .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
                    .task(id: avatarPhotoItem) {
                        if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = Image(uiImage: uiImage)
                        }
                    }

                    CustomTextField(text: $text, keyBoardType: .default, placeHolder: "test", textFieldType: .sign)
                        .padding(.horizontal, 16)

                    Button(action: {
                        withAnimation {
                            coordinator.showInviteFriendView = true
                        }
                    }) {
                        Text("Ajouter des amis")
                    }.padding(.top, 15)

                    Spacer()

                    LargeButtonView(
                        action: {},
                        title: "Créer la team",
                        largeButtonType: .teamCreate
                    )
                    .padding(.horizontal, 16)
                }
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

    var body: some View {
        DraggableView(isPresented: $showDetail) {
            SafeAreaContainer {
                HStack{
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
                Bazar()
            }
        }
    }
}
#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamFormView(showDetail: .constant(true), coordinator: Coordinator())
    }.ignoresSafeArea()
}
