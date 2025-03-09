//
//  EditProfileUser.swift
//  CFQ
//
//  Created by Calvignac Charles on 28/02/2025.
//

import SwiftUI
import PhotosUI

struct EditProfileUserView: View {
    @Binding var showDetail: Bool
    @State private var dragOffset: CGFloat = 0
    @ObservedObject var viewModel: SettingsViewModel
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isPhotoPickerPresented = false
    @EnvironmentObject var user: User

    private func showPhotoPicker() {
        isPhotoPickerPresented = true
    }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack(alignment: .center, spacing: 30) {
                    Button(
                        action: {
                            withAnimation {
                                showDetail = false
                            }
                        },
                        label: {
                            Image(.iconArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    )

                    Text("Mon Profil")
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)

                    Spacer()
                    
                }
                .background(.black)
                .padding(.leading, 20)
                
                Divider()
                    .background(.white)
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
        
        .offset(x: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width > 0 {
                        dragOffset = value.translation.width
                    }
                }
                .onEnded { value in
                    if value.translation.width > 150 {
                        withAnimation {
                            showDetail = false
                        }
                    } else {
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
}
