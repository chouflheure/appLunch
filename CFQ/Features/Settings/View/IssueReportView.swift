import PhotosUI
import SwiftUI

struct IssueReportView: View {
    @Binding var showDetail: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var avatarPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isPhotoPickerPresented = false
    @State private var isShowingMailView = false
    @State private var text = String()

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
                        titleScreen: StringsToken.Settings.headerABug
                    )
                    
                    Button(action: {
                        showPhotoPicker()
                    }) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 200)
                            .foregroundColor(.black)
                            .overlay(
                                ZStack(alignment: .bottom) {
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 20)
                                            )
                                            .frame(width: 100, height: 200)
                                    } else {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                style: StrokeStyle(lineWidth: 0.5)
                                            )
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "photo.artframe")
                                            .foregroundColor(.white)
                                            .scaleEffect(CGFloat(2))
                                            .frame(width: 40, height: 40)
                                            .padding(.bottom, 15)
                                        
                                    }
                                }
                            )
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 30)
                    
                    TextField("Vos commentaires", text: $text, axis: .vertical)
                        .foregroundColor(.white)
                        .lineLimit(5...10)
                        .padding()
                        .background(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 0.5)
                        )
                    
                    Spacer()
                    
                    LargeButtonView(
                        action: {
                            self.isShowingMailView = true
                        },
                        title: StringsToken.Settings.shareReport,
                        largeButtonType: .settings
                    )
                    .padding(.bottom, 50)
                    .padding(.horizontal, 16)
                }
                .sheet(isPresented: $isShowingMailView) {
                    IssueReportViewModel(
                        recipients: [StringsToken.Settings.adressForMail],
                        subject: StringsToken.Settings.subject,
                        messageBody: text,
                        image: selectedImage
                    )
                }
                .padding(.top, 50)
                .photosPicker(
                    isPresented: $isPhotoPickerPresented,
                    selection: $avatarPhotoItem,
                    matching: .images
                )
                .task(id: avatarPhotoItem) {
                    if let data = try? await avatarPhotoItem?.loadTransferable(
                        type: Data.self),
                       let uiImage = UIImage(data: data)
                    {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
}

#Preview {
    IssueReportView(showDetail: .constant(true))
}
