
import SwiftUI

struct AttendingGuestsView: View {
    @State var selection = 1
    var body: some View {
        VStack {
            PageView(pageViewType: .attendingGuestsView)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        AttendingGuestsView()
    }.ignoresSafeArea()
    
}
