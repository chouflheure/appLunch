
import SwiftUI

struct CellInformationOnePerson: View {
    var personInitNotif: String
    var bodyNotif: String
    var event: String?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.header)
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .padding(.trailing, 5)
                
                HStack {
                    (Text("Demande d'ami de ")
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(" ")
                     + Text("Mathilde ")
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text(" ")
                        .tokenFont(.Body_Inter_Medium_14)
                    )
                    .multilineTextAlignment(.leading)
                }
                .frame(height: 40)
                .padding(.trailing, 12)

                Spacer()
            }
        }
        .padding(.horizontal, 12)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellInformationOnePerson(
            personInitNotif: "pedrox",
            bodyNotif: "vont à",
            event: "MY BIRTHDAY"
        )
    }
}
