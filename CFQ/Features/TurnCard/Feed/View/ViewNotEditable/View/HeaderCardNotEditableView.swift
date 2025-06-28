
import SwiftUI

struct HeaderCardNotEditableView: View {
    
    @ObservedObject var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                if !turn.pictureURLString.isEmpty {
                    GeometryReader { geometry in
                        CachedAsyncImageView(urlString: turn.pictureURLString, designType: .scaledToFill_Clipped)
                    }
                }
                
                HStack(alignment: .center) {
                    DateLabel(
                        dayEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.dateStartEvent).jour,
                        monthEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.dateStartEvent).mois
                    )
                    
                    Spacer()
           
                    Text("Turn")
                        .tokenFont(.Title_Gigalypse_24)
                        .bold()
                        .textCase(.uppercase)
                    
                }
                .padding(.top, !turn.pictureURLString.isEmpty ? 20 : 100)
                .padding(.horizontal, 16)
            }
            .frame(height: 150)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
    }
}

class FormattedDateAndTime {
    
    func textFormattedShortFormat(date: Date?) -> (jour: String, mois: String) {
        let formatter = DateFormatter()
        var jour = ""
        var mois = ""
        
        if let date = date {
            formatter.dateFormat = "d"
            formatter.locale = Locale(identifier: "fr_FR")
            jour = formatter.string(from: date).capitalized
            
            formatter.dateFormat = "MMM"
            formatter.locale = Locale(identifier: "fr_FR")
            mois = formatter.string(from: date).uppercased()
        }

        return (jour, mois)
    }
    
    
    func textFormattedLongFormat(date: Date?) -> String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    func textFormattedHours(hours: Date?) -> String {
        if let time = hours {
            return time.formatted(date: .omitted, time: .shortened)
        }
        return ""
    }
    
    
}
