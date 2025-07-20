
import SwiftUI

struct CustomToggleStatus: View {
    @StateObject var viewModel: SwitchStatusUserProfileViewModel
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 60, height: 28)
                .foregroundColor(.black)
                .overlay(
                    Capsule()
                        .stroke(.white,
                                lineWidth: 0.5)
                )
            ZStack {
                Circle()
                    .frame(width: 26, height: 26)
                    .foregroundColor(.black)
                    .overlay(
                        Circle()
                            .stroke(viewModel.user.isActive ? .active : .inactive)
                    )
                Image(viewModel.user.isActive ? .disco : .moonStars)
            }
            .offset(x: viewModel.user.isActive ? 16 : -16)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.user.isActive.toggle()
                    viewModel.objectWillChange.send()
                    Logger.log("status toogle is : \(viewModel.user.isActive)", level: .info)
                }
            }
        }
    }
}
