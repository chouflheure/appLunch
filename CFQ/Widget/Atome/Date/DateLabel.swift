
import SwiftUI

struct DateLabel: View {
    var dayEventString: String
    var monthEventString: String
    
    var body: some View {
        
        VStack {
            Text(dayEventString)
                .foregroundColor(.white)
                .tokenFont(.Title_Inter_semibold_24)
                .padding(.top, 10)

            Text(monthEventString)
                .foregroundColor(.white)
                .tokenFont(.Label_Inter_Semibold_14)
                .textCase(.uppercase)
                .tint(.white)
                .padding(.bottom, 10)
                .frame(width: 60)
        }
        .background(.black.opacity(0.5))
        .cornerRadius(5)
    }
}

#Preview {
    DateLabel(dayEventString: "7", monthEventString: "Oct")
}
