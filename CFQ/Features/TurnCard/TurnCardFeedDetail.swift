
import SwiftUI

struct TurnCardDetailsFeedView: View {
    @ObservedObject var coordinator: Coordinator
    @State var showDetailTurnCard = false

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showTurnFeedDetail) {
            ZStack {
                GradientCardDetailView()
                ScrollView {
                    VStack {
                        // Header ( Date / Picture / TURN )
                        HeaderCardViewFeedDetailView(
                            turn: checkTurnSelectedNotNull(),
                            onClickBackArrow: {
                                withAnimation {
                                    coordinator.showTurnFeedDetail = false
                                }
                            })
                            .padding(.bottom, 15)
                            .frame(height: 200)

                        // Title ( Title / Guest )
                        TitleTurnCardDetailFeedView(
                            turn: checkTurnSelectedNotNull(),
                            coordinator: coordinator
                        )
                        .padding(.horizontal, 16)
                        .zIndex(2)
                        
                        // Informations ( Mood / Date / Loc )
                        MainInformationsDetailFeedView(turn: checkTurnSelectedNotNull())
                            .padding(.horizontal, 16)
                        
                        // Description ( Bio event )
                        DescriptionTurnCardDetailFeedView(turn: checkTurnSelectedNotNull())
                            .padding(.horizontal, 16)
                            .padding(.bottom, 50)
                     
                        if coordinator.user?.uid == coordinator.turnSelected?.admin ?? "" {
                            Button(action: {
                                showDetailTurnCard = true
                            }) {
                                Text("@@@ Admin ")
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
                

            }
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $showDetailTurnCard) {
                TurnCardDetailsView(viewModel: TurnCardViewModel(turn: TurnPreview(uid: "", titleEvent: "", date: nil, admin: "", description: "", invited: [""], mood: [], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0, imageEvent: nil), coordinator: coordinator), coordinator: coordinator)
            }
        }
    }

    private func checkTurnSelectedNotNull() -> Turn {
        guard let turn = coordinator.turnSelected else {
            coordinator.showTurnFeedDetail = false
            return Turn(uid: "", titleEvent: "", date: nil, pictureURLString: "", admin: "", description: "", invited: [], participants: [], denied: [], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0, timestamp: Date())
        }
        
        return turn
    }
}


struct HeaderCardViewFeedDetailView: View {

    var turn: Turn
    var onClickBackArrow: () -> Void

    let formattedDateAndTime = FormattedDateAndTime()
    
    init(turn: Turn, onClickBackArrow: @escaping () -> Void) {
        self.turn = turn
        self.onClickBackArrow = onClickBackArrow
    }

    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .top) {
                    CachedAsyncImageView(urlString: turn.pictureURLString, designType: .fullScreenImageTurnDetail)
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            self.onClickBackArrow()
                        }, label: {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .padding(.all, 5)
                                .background(.gray)
                                .clipShape(Circle())
                        })

                        Spacer()

                        DateLabel(
                            dayEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).jour,
                            monthEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).mois
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

    var turn: Turn
    @ObservedObject var coordinator: Coordinator
    @State var status: TypeParticipateButton = .none

    init(turn: Turn, coordinator: Coordinator) {
        self.turn = turn
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .background {
                    Color.gray.opacity(0.6)
                        .blur(radius: 10)
                        .padding(-5) // Pour que le flou dépasse un peu du texte
                }
                .padding(.bottom, 16)

            HStack {
                CachedAsyncImageView(urlString: turn.adminContact?.profilePictureUrl ?? "", designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(turn.adminContact?.pseudo ?? "")
                    .tokenFont(.Body_Inter_Medium_16)
                    .textCase(.lowercase)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(
                    action: {
                        withAnimation {
                            coordinator.showSheetParticipateAnswers = coordinator.turnSelected?.adminContact?.uid != coordinator.user?.uid
                        }
                    },
                    selectedOption: (coordinator.turnSelected?.adminContact?.uid == coordinator.user?.uid) ? .constant(.yes) : $status
                )
            }
            // TODO: - Add participants
            PreviewProfile(pictures: [], previewProfileType: .userComming, numberUsers: 12)
                .padding(.vertical, 8)
        }
        .sheet(isPresented: $coordinator.showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $status)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(250)])
        }
         
    }
}


struct MainInformationsDetailFeedView: View {
    var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(turn.mood), id: \.self) { moodIndex in
                        Mood().data(for: MoodType.convertIntToMoodType(MoodType(rawValue: moodIndex)?.rawValue ?? 0))
                            .padding(.leading, 12)
                            .padding(.trailing, moodIndex == Array(turn.mood).last ? 12 : 0)
                    }
                }
            }
            
            HStack {
                Image(.iconDate)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.leading, 12)
                
                Text(formattedDateAndTime.textFormattedLongFormat(date: turn.date))
                    .tokenFont(.Body_Inter_Medium_16)

                Text(" | ")
                    .foregroundColor(.white)

                Text(formattedDateAndTime.textFormattedHours(hours: turn.date))
                    .tokenFont(.Placeholder_Inter_Regular_16)
            }

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
            }
            .padding(.horizontal, 12)
            
            if ((turn.link?.isEmpty) != nil) {
                HStack(alignment: .center) {
                    
                    Image(.iconLink)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    
                    Link(turn.linkTitle ?? "", destination: URL(string: turn.link ?? "") ?? URL(string: "https://www.google.com")!)
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
