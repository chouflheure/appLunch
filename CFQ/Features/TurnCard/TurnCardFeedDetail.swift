
import SwiftUI

struct TurnCardDetailsFeedView: View {
//     @StateObject var viewModel: TurnCardViewModel
    @ObservedObject var coordinator: Coordinator

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
                        TitleTurnCardDetailFeedView(turn: checkTurnSelectedNotNull())
                            .padding(.horizontal, 16)
                            .zIndex(2)
                        
                        // Informations ( Mood / Date / Loc )
                        MainInformationsDetailFeedView(turn: checkTurnSelectedNotNull())
                            .padding(.horizontal, 16)
                        
                        // Description ( Bio event )
                        DescriptionTurnCardDetailFeedView(turn: checkTurnSelectedNotNull())
                            .padding(.horizontal, 16)
                            .padding(.bottom, 50)
                        
                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func checkTurnSelectedNotNull() -> Turn {
        guard let turn = coordinator.turnSelected else {
            coordinator.showTurnFeedDetail = false
            return Turn(uid: "", titleEvent: "", date: nil, pictureURLString: "", admin: "", description: "", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0)
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
                    CachedAsyncImageView(urlString: turn.pictureURLString, designType: .fullScreenImageTurn)
                    
                    HStack(alignment: .center) {
                        Button(action: {
                            self.onClickBackArrow()
                        }, label: {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 16)
                        })

                        Spacer()

                        DateLabel(
                            dayEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).jour,
                            monthEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).mois
                        )
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}


struct TitleTurnCardDetailFeedView: View {

    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .padding(.bottom, 16)

            HStack {
                CachedAsyncImageView(urlString: turn.adminContact?.profilePictureUrl ?? "", designType: .scaledToFill_Circle)
                    .frame(width: 50, height: 50)

                Text(turn.adminContact?.pseudo ?? "")
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()
                    .onTapGesture {}

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {})
            }

            // TODO: - Add participants
            PreviewProfile(pictures: [], previewProfileType: .userComming)
                .padding(.vertical, 8)
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
                    ForEach(Array(turn.mood), id: \.self) { mood in
                        Mood().data(for: MoodType.convertIntToMoodType(MoodType(rawValue: mood)?.rawValue ?? 0))
                    }
                }
            }
            .padding(.horizontal, 12)
            
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

            HStack(alignment: .top) {
                
                Image(.iconLocation)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Text("Lieu")
                    .foregroundColor(.white)
                    
                Text("|")
                    .foregroundColor(.white)
                
                Text("92240 Malakoff ")
                    .tokenFont(.Placeholder_Inter_Regular_16)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
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
                .tokenFont(.Body_Inter_Medium_14)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
