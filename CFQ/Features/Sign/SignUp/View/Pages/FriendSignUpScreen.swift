import Lottie
import SwiftUI

struct FriendSignUpScreen: View {
    @ObservedObject var viewModel: SignUpPageViewModel
    @State private var toast: Toast? = nil
    @State private var isLoadingSendButton = false
    @State var isLoadingPictureUpload = false
    @State var isLoadingPictureUploadDone = false
    @State var isLoadingPictureUploadError = false
    @State var isLoadingUserUpload = false

    var coordinator: Coordinator
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            VStack {
                ProgressBar(index: $viewModel.index)
                    .padding(.bottom, 30)

                ScrollView {
                    VStack {
                        Text(StringsToken.Sign.TitleFindYourFriends)
                            .tokenFont(.Title_Gigalypse_24)
                            .textCase(.uppercase)
                            .padding(.bottom, 50)

                        ForEach(viewModel.contacts, id: \.self) { contact in
                            HStack {
                                if viewModel.isFetchingContacts {
                                    LottieView(
                                        animation: .named(
                                            StringsToken.Animation.loaderCircle
                                        )
                                    )
                                    .playing()
                                    .looping()
                                    .frame(width: 150, height: 150)
                                } else {
                                    FriendSignUpCell(
                                        userPreview: contact
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .init(horizontal: .center, vertical: .top)
                )
                .background(.clear)

                Spacer()

                // TODO: - Edit le success et l'erreur
                VStack {
                    if isLoadingUserUpload {
                        LottieView(
                            animation: .named(
                                StringsToken.Animation.loaderCircle)
                        )
                        .playing()
                        .looping()
                    } else {
                        LargeButtonView(
                            action: {
                                viewModel.addUserDataOnDataBase(
                                    coordinator: coordinator
                                ) { success, message in
                                    if !success {
                                        toast = Toast(
                                            style: .error,
                                            message: message
                                        )
                                    }
                                }
                                isLoadingUserUpload = false
                            },
                            title: StringsToken.Sign.WelcomeToCFQ,
                            largeButtonType: .signNext,
                            isDisabled: isLoadingPictureUpload
                                || isLoadingPictureUploadError
                                || isLoadingPictureUploadDone
                                || isLoadingUserUpload
                        ).padding(.horizontal, 20)

                        LargeButtonView(
                            action: { viewModel.goBack() },
                            title: StringsToken.Sign.TitleBackStep,
                            largeButtonType: .signBack,
                            isDisabled: isLoadingPictureUpload
                                || isLoadingPictureUploadError
                                || isLoadingPictureUploadDone
                                || isLoadingUserUpload
                        ).padding(.horizontal, 20)
                    }
                }
            }
            .blur(
                radius: isLoadingPictureUpload || isLoadingPictureUploadError
                    || isLoadingPictureUploadDone ? 10 : 0
            )
            .allowsHitTesting(
                !isLoadingPictureUpload || !isLoadingPictureUploadError
                    || !isLoadingPictureUploadDone
            )

            .onChange(of: viewModel.isLoadingPictureUpload) { isLoading in
                isLoadingPictureUpload = isLoading
            }

            .onChange(of: viewModel.isLoadingPictureUploadError) { isLoading in
                // startAnimationTimer(totalFrames: ResponseUploadType.error.totalFrames)
                isLoadingPictureUploadError = isLoading
            }

            .onChange(of: viewModel.isLoadingPictureUploadDone) { isLoading in
                // startAnimationTimer(totalFrames: ResponseUploadType.done.totalFrames)
                isLoadingPictureUploadDone = isLoading
            }

            .onChange(of: viewModel.isLoadingCreateUser) { isLoading in
                isLoadingUserUpload = isLoading
            }
            .toastView(toast: $toast)

            

            if isLoadingPictureUpload {
                UploadPictureOnDataBase()
                    .zIndex(2)
            }

            if isLoadingPictureUploadError {
                UploadPictureOnDataBaseResponse(response: .error)
                    .zIndex(3)
            }

            if isLoadingPictureUploadDone {
                UploadPictureOnDataBaseResponse(response: .done)
                    .zIndex(3)
            }
        }
        .fullBackground(imageName: "backgroundNeon")
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            viewModel.fetchContacts()
        }
    }

    func startAnimationTimer(totalFrames: Int) {
        // Supposons que chaque frame dure 0.033 secondes (30 FPS)
        let frameDuration = 0.033
        let totalFrames = totalFrames  // 150 - 130 error et autre 180 - 70
        let animationDuration = frameDuration * Double(totalFrames)

        // Démarrez un timer qui se déclenche à la fin de l'animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
            isLoadingPictureUpload = false
            isLoadingPictureUploadDone = false
            isLoadingPictureUploadError = false
            print("Animation terminée")
        }

    }
}

#Preview {
    FriendSignUpScreen(
        viewModel: SignUpPageViewModel(uidUser: ""), coordinator: Coordinator()
    ) {}
}

enum ResponseUploadType {
    case done
    case error

    var totalFrames: Int {
        switch self {
        case .done:
            return 180 - 80
        case .error:
            return 150 - 130
        }
    }
}

struct FrameTest: View {
    var body: some View {
        LottieView(
            animation: .named(StringsToken.Animation.loaderUpdatePicture)
        )
        .playbackMode(
            .playing(
                .fromFrame(
                    95,
                    toFrame: 180,
                    loopMode: .loop
                )
            )
        )
        .frame(width: 120, height: 120)
    }
}

#Preview {
    FrameTest()
}

struct UploadPictureOnDataBaseResponse: View {
    var response: ResponseUploadType

    var body: some View {
        ZStack {

            VStack(spacing: 20) {
                Text("Mise à jour de votre photo de profil")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 300, height: 200)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)

            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purpleText)
                    .shadow(radius: 10)

                if response == .done {
                    LottieView(
                        animation: .named(
                            StringsToken.Animation.loaderUpdatePicture)
                    )
                    .playbackMode(
                        .playing(
                            .fromFrame(
                                95,
                                toFrame: 180,
                                loopMode: .repeat(0)
                            )
                        )
                    )
                    .frame(width: 120, height: 120)
                } else {
                    LottieView(
                        animation: .named(StringsToken.Animation.loaderError)
                    )
                    .playbackMode(
                        .playing(
                            .fromFrame(
                                90,
                                toFrame: 151,
                                loopMode: .repeat(0)
                            )
                        )
                    )
                    .frame(width: 120, height: 120)
                }

            }
            .offset(y: -110)
            .zIndex(4)
        }
    }
}

struct UploadPictureOnDataBase: View {
    var isReceiveData: Bool = false

    var body: some View {
        ZStack {

            VStack(spacing: 20) {
                Text("Mise à jour de votre photo de profil")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 300, height: 200)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)

            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purpleText)
                    .shadow(radius: 10)

                LottieView(
                    animation: .named(
                        StringsToken.Animation.loaderUpdatePicture)
                )
                .playbackMode(
                    .playing(
                        .fromFrame(
                            1,
                            toFrame: 95,
                            loopMode: .loop
                        )
                    )
                )
                .frame(width: 120, height: 120)
            }
            .offset(y: -110)
            .zIndex(3)
        }
    }
}

struct FriendSignUpCell: View {
    let userPreview: UserContact
    @State var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 15) {
            CirclePicture(urlStringImage: userPreview.profilePictureUrl)
                .frame(width: 40, height: 40)
            Text(userPreview.pseudo)
                .tokenFont(.Body_Inter_Medium_16)
            Text(
                "~ " + userPreview.name + " "
                    + userPreview.firstName.first!.uppercased() + "."
            )
            .tokenFont(.Placeholder_Inter_Regular_16)

            Spacer()

            Button(action: {
                withAnimation {
                    isSelected.toggle()
                }
                if isSelected {
                    Logger.log(
                        "Demande d'ajout d'ami lors de l'inscription",
                        level: .info)
                } else {
                    Logger.log("Annulation de la demande d'ami", level: .info)
                }
            }) {
                if isSelected {
                    Text("Annuler")
                        .foregroundColor(.red)
                } else {
                    Image(.iconAdduser)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .init(horizontal: .leading, vertical: .top)
        )
        .padding(.horizontal, 16)
    }
}
