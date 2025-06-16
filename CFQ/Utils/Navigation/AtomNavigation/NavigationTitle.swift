
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
