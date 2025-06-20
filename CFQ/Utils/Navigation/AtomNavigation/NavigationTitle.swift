
import SwiftUI

struct NavigationTitle: View {
    var title: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .tokenFont(.Title_Gigalypse_24)
                .textCase(.uppercase)
        }
    }
}


struct NavigationCFQHeader: View {
    var cfq: CFQ

    var body: some View {
        VStack(spacing: 2) {
            CFQMolecule(
                uid: cfq.uid,
                name: cfq.userContact?.name ?? "",
                title: cfq.title,
                image: cfq.userContact?.profilePictureUrl ?? ""
            )
        }
    }
}
