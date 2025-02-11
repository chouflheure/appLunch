
import SwiftUI

struct CustomToggleStatus: View {
    @State var isActive = false
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 50, height: 22)
                .foregroundColor(.black)
                .overlay(
                    Capsule()
                        .stroke(.white,
                                lineWidth: 0.5)
                )
            ZStack {
                Circle()
                    .frame(width: 22, height: 22)
                    .foregroundColor(.black)
                    .overlay(
                        Circle()
                            .stroke(isActive ? .active : .inactive)
                    )
                Image( isActive ? .disco : .moonStars)
            }
            .offset(x: isActive ? 14 : -14)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isActive.toggle()
                    Logger.log("status toogle is : \(isActive)", level: .info)
                }
            }
        }
    }
}
