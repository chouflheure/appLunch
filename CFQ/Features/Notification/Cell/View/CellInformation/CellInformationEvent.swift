
import SwiftUI

struct CellInformationEvent: View {
    var userContact: UserContact
    var bodyNotif: NotificationsType
    var notification: Notification

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ModernCachedAsyncImage(url: userContact.profilePictureUrl, placeholder: Image(systemName: "photo.fill"))
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 5)

                HStack {
                    (Text(userContact.pseudo)
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(" ")
                     + Text(bodyNotif.bodyNotif())
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text(notification.titleEvent)
                        .tokenFont(.Body_Inter_Medium_14)
                    )
                    .multilineTextAlignment(.leading)
                }
                .frame(height: 40)
                .padding(.trailing, 12)

                Spacer()
                
                Text(timeAgoSinceDate(notification.timestamp))
                    .tokenFont(.Placeholder_Inter_Regular_14)
            }
        }
        .padding(.horizontal, 12)
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
