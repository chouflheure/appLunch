
import SwiftUI

struct MainInformationsPreviewFeedView: View {
    
    @ObservedObject var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()

    init(turn: Turn) {
        self.turn = turn
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if turn.mood.isEmpty {
                            MoodTemplateView()
                        } else {
                            ForEach(Array(turn.mood), id: \.self) { moodIndex in
                                Mood().data(for: MoodType(rawValue: moodIndex) ?? .other)
                                    .padding(.leading, 12)
                                    .padding(.trailing, moodIndex == Array(turn.mood).last ? 12 : 0)
                            }
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
