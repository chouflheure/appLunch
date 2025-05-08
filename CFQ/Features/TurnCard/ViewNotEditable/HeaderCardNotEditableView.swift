
import SwiftUI

struct HeaderCardNotEditableView: View {
    
    var turn: Turn
    let formattedDateAndTime = FormattedDateAndTime()

    init(turn: Turn) {
        self.turn = turn
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                GeometryReader { geometry in
                    CachedAsyncImageView(urlString: turn.pictureURLString, designType: .scaledToFill_Clipped)
                }
                
                DateLabel(
                    dayEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).jour,
                    monthEventString: formattedDateAndTime.textFormattedShortFormat(date: turn.date).mois
                )
                .padding(.top, 20)
                .padding(.leading, 16)
            }
            .frame(height: 100)
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
