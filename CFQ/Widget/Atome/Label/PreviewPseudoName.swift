
import SwiftUI

struct PreviewPseudoName: View {
    var name: String
    var pseudo: String
    
    var body: some View {
        HStack {
            Text(pseudo)
                .tokenFont(.Body_Inter_Medium_16)
            Text("~ " + name)
        }
    }
}
