import SwiftUI

struct MainInformationsPreviewFeedView: View {

    @ObservedObject var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()
    @State private var isShowMaps: Bool = false
    private var paddinBottom = 12.0
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
                            for: MoodType(rawValue: moodIndex) ?? .other
                        )
                        .padding(.leading, 12)
                        .padding(
                            .trailing,
                            moodIndex == Array(turn.mood).last ? 12 : 0)
                    }
                }
            }
            .padding(.bottom, paddinBottom)

            HStack {

                Image(.iconDate)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.leading, 12)

                Text(formattedDateAndTime.textFormattedLongFormat(date: turn.dateStartEvent))
                    .tokenFont(.Body_Inter_Medium_16)

                Text(" | ")
                    .foregroundColor(.white)

                Text(formattedDateAndTime.textFormattedHours(hours: turn.dateStartEvent))
                    .tokenFont(.Placeholder_Inter_Regular_16)

            }
            .padding(.bottom, !formattedDateAndTime.textFormattedLongFormat(date: turn.dateEndEvent).isEmpty ? 0 : paddinBottom)
            
            if !formattedDateAndTime.textFormattedLongFormat(date: turn.dateEndEvent).isEmpty {
                HStack {
                    Text(" ~ ")
                        .foregroundColor(.white)
                    Text(formattedDateAndTime.textFormattedLongFormat(date: turn.dateEndEvent))
                        .tokenFont(.Body_Inter_Medium_16)
                    
                    Text(" | ")
                        .foregroundColor(.white)
                    
                    Text(formattedDateAndTime.textFormattedHours(hours: turn.dateEndEvent))
                        .tokenFont(.Placeholder_Inter_Regular_16)
                }
                .padding(.leading, 12)
                .padding(.bottom, !formattedDateAndTime.textFormattedLongFormat(date: turn.dateEndEvent).isEmpty ? paddinBottom : 0)
            }

            Button(action: {
                isShowMaps = true
            }) {
                HStack(alignment: .center) {

                    Image(.iconLocation)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)

                    Text(turn.placeTitle)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text("|")
                        .foregroundColor(.white)

                    Text(turn.placeAdresse)
                        .tokenFont(.Placeholder_Inter_Regular_16)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
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
                    })
            }
            .padding(.horizontal, 12)
            .padding(.bottom, (turn.link?.isEmpty) != nil ? paddinBottom : 5)

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
