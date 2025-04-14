
import SwiftUI

struct CellMessagingView: View {
    var data: MessageCellModel
    var onTap: ((String) -> Void)

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: data.hasUnReadMessage ? 0 : 20) {
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 45, height: 45)
                    .padding(.trailing, 0)
                
                if data.hasUnReadMessage {
                    Circle()
                        .fill(.purpleLight)
                        .frame(width: 15, height: 15)
                        .offset(x: -50, y: -16)
                }
                
                VStack(alignment: .leading, spacing: 6) {

                    Text(data.titleConversation)
                        .tokenFont(.Body_Inter_Medium_14)
                        .lineLimit(1)

                    Text(data.hasUnReadMessage ? StringsToken.Messaging.newMessagePreview : data.messagePreview)
                        .tokenFont(
                            data.hasUnReadMessage ?
                                .Body_Inter_Medium_14 :
                                .Placeholder_Inter_Regular_14
                        )
                        .lineLimit(1)

                }.bold(data.hasUnReadMessage)

                Spacer()

                Text(data.time)
                    .tokenFont(.Placeholder_Inter_Regular_14)
            }
        }
        .padding(.horizontal, 12)
        .onTapGesture {
            onTap(data.uid)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellMessagingView(
            data: MessageCellModel(
                    uid: "1",
                    titleConversation: "Charles",
                    messagePreview: "Coucou",
                    time: "4min",
                    hasUnReadMessage: true
            ),
            onTap: {_ in }
        )
    }.ignoresSafeArea()
}
