
import SwiftUI

struct PreviewPseudoName: View {
    var name: String
    var firstName: String
    var pseudo: String
    
    var body: some View {
        HStack {
            Text(pseudo)
                .tokenFont(.Body_Inter_Medium_16)
            Text("~ " + name + " " + firstName.first!.uppercased() + ".")
                .tokenFont(.Placeholder_Inter_Regular_16)
        }
    }
}
