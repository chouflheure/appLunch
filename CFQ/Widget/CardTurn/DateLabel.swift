
import SwiftUI

struct DateLabel: View {
    var dayEventString: String
    var monthEventString: String
    
    var body: some View {
        
        VStack {
            Text(dayEventString)
                .foregroundColor(.white)
                .font(.system(size: 25))
                .padding(.top, 10)

            Text(monthEventString)
                .foregroundColor(.white)
                .textCase(.uppercase)
                .font(.system(size: 20))
                .tint(.white)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)

        }
        .background(.black).opacity(0.8)
        .cornerRadius(10)
    }
}

#Preview {
    DateLabel(dayEventString: "7", monthEventString: "Oct")
}
