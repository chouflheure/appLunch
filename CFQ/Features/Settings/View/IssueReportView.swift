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

                    Text(StringsToken.Settings.headerABug)
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)

                    Spacer()

                }
                .background(.black)
                .padding(.leading, 20)

                Divider()
                    .background(.white)

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
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
    }
}

#Preview {
    IssueReportView(showDetail: .constant(true))
}
