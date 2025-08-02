import SwiftUI

struct TurnCardDetailsFeedView: View {
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var turn: Turn
    @StateObject var viewModel: TurnCardDetailsFeedViewModel
    @StateObject var turnCardViewModel: TurnCardViewModel
    @State private var toast: Toast? = nil
    @Environment(\.dismiss) var dismiss
    @State var showAlertRemoveTurn = false

    var user: User

    init(coordinator: Coordinator, turn: Turn, user: User) {
        self.coordinator = coordinator
        self.turn = turn
        self.user = user
        self._viewModel = StateObject(wrappedValue: TurnCardDetailsFeedViewModel(turn: turn))
        self._turnCardViewModel = StateObject(
            wrappedValue: TurnCardViewModel(
                turn: turn,
                coordinator: coordinator,
                isEditing: turn.admin == user.uid
            )
        )
    }
    
    var body: some View {
        ZStack {
            GradientCardDetailView()
            ScrollView {
                VStack {
                    // Header ( Date / Picture / TURN )
                    HeaderCardViewFeedDetailView(turn: viewModel.turn)
                        .padding(.bottom, 15)
                        .frame(height: !turn.pictureURLString.isEmpty ? 200 : 100)
                    
                    // Title ( Title / Guest )
                    TitleTurnCardDetailFeedView(
                        turn: viewModel.turn,
                        coordinator: coordinator,
                        user: user
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, !turn.pictureURLString.isEmpty ? 0 : 70)
                    
                    // Informations ( Mood / Date / Loc )
                    MainInformationsDetailFeedView(turn: viewModel.turn, coordinator: coordinator)
                        .padding(.horizontal, 16)
                    
                    // Description ( Bio event )
                    DescriptionTurnCardDetailFeedView(turn: viewModel.turn)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 50)
                    
                    Spacer()
                }
            }
            
            if turn.admin == user.uid {
                VStack {
                    Spacer()
                    

                    HStack(spacing: 30) {
                        Button(action: {
                            showAlertRemoveTurn.toggle()
                        }, label: {
                            HStack {
                                Image(.iconTrash)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                    .foregroundColor(.white)
                                    .padding(.leading, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 10, weight: .bold))
                                
                                Text("Supprimer")
                                    .tokenFont(.Body_Inter_Medium_14)
                                    .padding(.trailing, 15)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 15, weight: .bold))
                            }
                        })
                        .frame(width: 150)
                        .background(.clear)
                        .cornerRadius(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.white)
                                .background(.clear)
                        }
                        .alert(isPresented: $showAlertRemoveTurn) {
                            CustomAlertDoubleButton(
                                title: "Tu surpprime ce TURN, t'es sur ?",
                                content: .trash,
                                button1Title: "Garder",
                                button2Title: "Poubelle",
                                onDismissAlert: {
                                    showAlertRemoveTurn = false
                                },
                                onTapValidate: {
                                    showAlertRemoveTurn = false
                                    turnCardViewModel
                                        .removeturn(
                                            uid: viewModel.turn.uid,
                                        ) {
                                            success, message in
                                            if success {
                                                dismiss()
                                            } else {
                                                toast = Toast(
                                                    style: .error,
                                                    message: message
                                                )
                                            }
                                        }
                                }
                            ).transition(.blurReplace)
                        } background: {
                            Rectangle()
                                .fill(.primary.opacity(0.35))
                        }
                        
                        Button(
                            action: {
                                turnCardViewModel.showDetailTurnCard = true
                            },
                            label: {
                                HStack {
                                    Image(.iconEdit)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 30)
                                        .foregroundColor(.white)
                                        .padding(.leading, 15)
                                        .padding(.vertical, 10)
                                        .font(.system(size: 10, weight: .bold))
                                    
                                    Text("Modifier")
                                        .tokenFont(.Body_Inter_Medium_14)
                                        .padding(.trailing, 15)
                                        .padding(.vertical, 10)
                                        .bold()
                                }
                            }
                        )
                        .frame(width: 150)
                        .background(Color(hex: "B098E6").opacity(1))
                        .cornerRadius(10)
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
        .ignoresSafeArea()
        .customNavigationBackButton{}
        .fullScreenCover(isPresented: $turnCardViewModel.showDetailTurnCard) {
            TurnCardDetailsView(
                viewModel: turnCardViewModel,
                parentDismiss: dismiss
            )
        }
    }
}

struct HeaderCardViewFeedDetailView: View {

    var turn: Turn
    @Environment(\.dismiss) var dismiss

    let formattedDateAndTime = FormattedDateAndTime()

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .top) {
                    if !turn.pictureURLString.isEmpty {
                        CachedAsyncImageView(
                            urlString: turn.pictureURLString,
                            designType: .fullScreenImageTurnDetail
                        )
                    }

                    HStack(alignment: .center) {
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Image(.iconArrow)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .padding(.all, 5)
                                    .background(.gray)
                                    .clipShape(Circle())
                            })

                        Spacer()

                        DateLabel(
                            dayEventString:
                                formattedDateAndTime.textFormattedShortFormat(
                                    date: turn.dateStartEvent
                                ).jour,
                            monthEventString:
                                formattedDateAndTime.textFormattedShortFormat(
                                    date: turn.dateStartEvent
                                ).mois
                        )
                    }
                    .padding(.top, 100)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct TitleTurnCardDetailFeedView: View {

    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    var user: User
    @State var showSheetParticipateAnswers: Bool = false

    init(turn: Turn, coordinator: Coordinator, user: User) {
        self.turn = turn
        self.coordinator = coordinator
        self.user = user
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .background {
                    if !turn.pictureURLString.isEmpty {
                        Color.gray.opacity(0.6)
                            .blur(radius: 10)
                            .padding(0)  // Pour que le flou dépasse un peu du texte
                    }
                }
                .padding(.bottom, 16)

            HStack {
                
                if turn.admin == user.uid {
                    CachedAsyncImageView(
                        urlString: turn.adminContact?.profilePictureUrl ?? "",
                        designType: .scaledToFill_Circle
                    )
                    .frame(width: 50, height: 50)

                    Text(turn.adminContact?.pseudo ?? "")
                        .tokenFont(.Body_Inter_Medium_16)
                        .textCase(.lowercase)
                        .lineLimit(1)
                } else {
                    NavigationLink(
                        destination: FriendProfileView(
                            coordinator: coordinator,
                            user: user,
                            friend: turn.adminContact ?? UserContact()
                        )
                    ) {
                        CachedAsyncImageView(
                            urlString: turn.adminContact?.profilePictureUrl ?? "",
                            designType: .scaledToFill_Circle
                        )
                        .frame(width: 50, height: 50)
                        
                        Text(turn.adminContact?.pseudo ?? "")
                            .tokenFont(.Body_Inter_Medium_16)
                            .textCase(.lowercase)
                            .lineLimit(1)
                    }
                }
                Spacer()

                NavigationLink(
                    destination: MessagerieView(
                        coordinator: coordinator,
                        conversation: Conversation(
                            uid: turn.messagerieUUID,
                            titleConv: turn.titleEvent,
                            pictureEventURL: turn.pictureURLString,
                            typeEvent: "turn",
                            eventUID: turn.uid,
                            lastMessageSender: "",
                            lastMessageDate: Date(),
                            lastMessage: "",
                            messageReader: []
                        ),
                        turn: turn
                    )
                ) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(
                    action: {
                        withAnimation {
                            showSheetParticipateAnswers = turn.adminContact?.uid != user.uid
                        }
                    },
                    selectedOption: (turn.adminContact?.uid == user.uid) ?
                        .constant(.yourEvent) : $turn.userStatusParticipate
                )
            }
            // TODO: - Add participants
            /*
            PreviewProfile(
                pictures: [], previewProfileType: .userComming, numberUsers: 12
            )
            .padding(.vertical, 8)
             */
        }
        .sheet(isPresented: $showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $turn.userStatusParticipate)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(250)])
        }

    }
}

struct MainInformationsDetailFeedView: View {
    var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()
    @State private var isShowMaps: Bool = false
    @ObservedObject var coordinator: Coordinator

    init(turn: Turn, coordinator: Coordinator) {
        self.turn = turn
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(turn.mood), id: \.self) { moodIndex in
                        Mood().data(
                            for: MoodType.convertIntToMoodType(
                                MoodType(rawValue: moodIndex)?.rawValue ?? 0)
                        )
                        .padding(.leading, 12)
                        .padding(
                            .trailing,
                            moodIndex == Array(turn.mood).last ? 12 : 0)
                    }
                }
                .padding(.bottom, 20)
            }

            HStack {
                Image(.iconDate)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.leading, 12)

                Text(
                    formattedDateAndTime.textFormattedLongFormat(
                        date: turn.dateStartEvent)
                )
                .tokenFont(.Body_Inter_Medium_16)

                Text(" | ")
                    .foregroundColor(.white)

                Text(
                    formattedDateAndTime.textFormattedHours(
                        hours: turn.dateStartEvent)
                )
                .tokenFont(.Placeholder_Inter_Regular_16)
            }
            .padding(
                .bottom,
                !formattedDateAndTime.textFormattedLongFormat(
                    date: turn.dateEndEvent
                ).isEmpty ? 0 : 20)

            if !formattedDateAndTime.textFormattedLongFormat(
                date: turn.dateEndEvent
            ).isEmpty {
                HStack {
                    Text(" ~ ")
                        .foregroundColor(.white)
                    Text(
                        formattedDateAndTime.textFormattedLongFormat(
                            date: turn.dateEndEvent)
                    )
                    .tokenFont(.Body_Inter_Medium_16)

                    Text(" | ")
                        .foregroundColor(.white)

                    Text(
                        formattedDateAndTime.textFormattedHours(
                            hours: turn.dateEndEvent)
                    )
                    .tokenFont(.Placeholder_Inter_Regular_16)
                }
                .padding(.leading, 12)
                .padding(
                    .bottom,
                    !formattedDateAndTime.textFormattedLongFormat(
                        date: turn.dateEndEvent
                    ).isEmpty ? 20 : 0)
            }

            Button(action: {
                isShowMaps = true
            }) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center) {

                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)

                        Text(turn.placeTitle)
                            .foregroundColor(.white)
                    }

                    Text(turn.placeAdresse)
                        .tokenFont(.Placeholder_Inter_Regular_16)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                }
            }
            .padding(.horizontal, 12)
            .alert(
                "Ouvrir l'adresse dans :", isPresented: $isShowMaps,
                actions: {
                    Button("Ouvrir avec Apple Maps") {
                        let url = URL(
                            string:
                                "maps://?saddr=&daddr=\(turn.placeLatitude),\(turn.placeLongitude)"
                        )
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(
                                url!, options: [:], completionHandler: nil)
                        }
                    }

                    Button("Ouvrir avec Google Maps") {
                        let url = URL(
                            string:
                                "comgooglemaps://?saddr=&daddr=\(turn.placeLatitude),\(turn.placeLongitude)"
                        )
                        if UIApplication.shared.canOpenURL(url!) {
                            UIApplication.shared.open(
                                url!, options: [:], completionHandler: nil)
                        }
                    }

                    Button(StringsToken.General.cancel, role: .cancel) {
                        isShowMaps = false
                    }
                }
            )
            .padding(.bottom, (turn.link?.isEmpty) != nil ? 20 : 5)

            if (turn.link?.isEmpty) != nil {
                HStack(alignment: .center) {

                    Image(.iconLink)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)

                    Link(
                        turn.linkTitle ?? "",
                        destination: URL(string: turn.link ?? "") ?? URL(
                            string: "https://www.google.com")!
                    )
                    .tokenFont(.Body_Inter_Medium_14)
                    .lineLimit(1)
                }
                .padding(.horizontal, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white, lineWidth: 0.8)
        )
        
        NavigationLink(destination: {
            FriendListStatusTurnInvitation(turn: turn, coordinator: coordinator)
        }) {
            HStack {
                Text("\(turn.participants.count) y vont")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top, 5)
        }
    }
}

struct DescriptionTurnCardDetailFeedView: View {

    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        HStack {
            Text(turn.description)
                .tokenFont(.Body_Inter_Regular_14)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
