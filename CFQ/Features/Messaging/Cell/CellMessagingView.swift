
import SwiftUI

struct CellMessagingView: View {
    var data: Conversation
    var hasUnReadMessage: Bool
    var onTap: ((String) -> Void)

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: hasUnReadMessage ? 0 : 12) {
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 45, height: 45)
                    .padding(.trailing, 0)
                
                if hasUnReadMessage {
                    Circle()
                        .fill(.purpleLight)
                        .frame(width: 15, height: 15)
                        .offset(x: -50, y: -16)
                }
                
                VStack(alignment: .leading, spacing: 6) {

                    Text(data.titleConv)
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                        .lineLimit(1)

                    HStack(spacing: 0) {
                        Text(data.lastMessageSender + " : ")
                            .tokenFont(.Body_Inter_Medium_14)
                            
                        Text(data.lastMessage)
                            .tokenFont(.Body_Inter_Medium_14)
                            .lineLimit(1)
                    }
                }.bold(hasUnReadMessage)

                Spacer()

                Text(timeAgoSinceDate(data.lastMessageDate ?? Date()))
                    .tokenFont(.Placeholder_Inter_Regular_14)
            }
        }
        .padding(.horizontal, 12)
        .onTapGesture {
            onTap(data.uid)
        }
    }
    
    func timeAgoSinceDate(_ date: Date, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now

        let components: DateComponents = calendar.dateComponents(
            [.minute, .hour, .day],
            from: earliest,
            to: latest
        )

        if let day = components.day, day > 0 {
            return "\(day)j"
        }

        if let hour = components.hour, hour > 0 {
            return "\(hour)h"
        }

        if let minute = components.minute, minute > 0 {
            return "\(minute) min"
        }

        return "maintenant"
    }
}


