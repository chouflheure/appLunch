
import SwiftUI

struct CellInformationMultiPerson: View {
    var personInitNotif: [String]
    var bodyNotif: String
    var event: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                PreviewDoublePicture()
                
                HStack {
                    (Text(personInitNotif[0])
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text("et")
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(" ")
                     + Text(personInitNotif[1])
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text(bodyNotif)
                        .tokenFont(.Body_Inter_Medium_14)
                     + Text(" ")
                     + Text(event)
                        .tokenFont(.Body_Inter_Medium_14)
                        .bold()
                     + Text(" ")
                     + Text("4min")
                        .tokenFont(.Placeholder_Inter_Regular_14)
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
        CellInformationMultiPerson(
            personInitNotif: ["pedrox", "sixmonstre"],
            bodyNotif: "vont à",
            event: "MY BIRTHDAY"
            
        )
    }
}
