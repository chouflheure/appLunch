
import SwiftUI

struct CellResponseFriend: View {
    var userContact: UserContact
    var timeStamp: Date
    var isAcceptedFriend: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ModernCachedAsyncImage(url: userContact.profilePictureUrl, placeholder: Image(systemName: "photo.fill"))
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 5)
                
                HStack {
                    (Text("Avec ")
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(userContact.pseudo)
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" vous êtes maintenant amis ")
                        .tokenFont(.Body_Inter_Medium_14)
                    )
                    .multilineTextAlignment(.leading)
                }
                .frame(height: 40)
                .padding(.trailing, 12)

                Spacer()
                
                Text(timeAgoSinceDate(timeStamp))
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


