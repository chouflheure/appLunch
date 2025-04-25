
import SwiftUI
import PhotosUI

struct EditProfileUserView: View {
    @Binding var showDetail: Bool
    @EnvironmentObject var user: User
    @ObservedObject var viewModel: SettingsViewModel

    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isPhotoPickerPresented = false

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
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
                        
                        Button(action: {
                            showPhotoPicker()
                        }) {
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
                        }
                        
                        CustomTextField(
                            text: $viewModel.pseudo,
                            keyBoardType: .default,
                            placeHolder: user.pseudo,
                            textFieldType: .editProfile
                        )
                        
                        CustomTextField(
                            text: $viewModel.name,
                            keyBoardType: .default,
                            placeHolder: user.name,
                            textFieldType: .editProfile
                        )
                        
                        CustomTextField(
                            text: $viewModel.firstName,
                            keyBoardType: .default,
                            placeHolder: user.firstName,
                            textFieldType: .editProfile
                        )
                        
                        CollectionViewLocalisations(selectedItems: $user.location)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                    
                    LargeButtonView(
                        action: {
                            
                        },
                        title: StringsToken.Settings.edit,
                        largeButtonType: .settings
                    )
                    .padding(.bottom, 50)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 50)
                .photosPicker(isPresented: $isPhotoPickerPresented, selection: $avatarPhotoItem, matching: .images)
                .task(id: avatarPhotoItem) {
                    if let data = try? await avatarPhotoItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
                
            }
        }
    }
}
