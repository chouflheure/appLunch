
import SwiftUI

struct NotificationsListView: View {
    @Binding var showDetail: Bool
    @State private var dragOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    @State private var notificationType = NotificationType.allCases
    
    @State private var isActive = false
    @StateObject var viewModel = NotificationsListViewModel()
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack(alignment: .center, spacing: 30) {
                    Button(
                        action: {
                            withAnimation {
                                showDetail = false
                            }
                        },
                        label: {
                            Image(.iconArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    )
                    
                    Text(StringsToken.Settings.headerNotifications)
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)
                    
                    Spacer()
                    
                }
                .background(.black)
                .padding(.leading, 20)
                
                Divider()
                    .background(.white)
                
                VStack(alignment: .leading) {
                    ForEach(notificationType, id: \.self) { info in
                        HStack{
                            Image(info.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                            Text(info.title)
                                .tokenFont(.Body_Inter_Medium_14)
                            
                            Spacer()
                            
                            CustomToggleNotifView(
                                isActive: Binding(
                                    get: { viewModel.isActiveStates[info.topic] ?? false },
                                    set: { newValue in
                                        viewModel.toggleSubscription(to: info.topic)
                                    }
                                ))
                            .padding(12)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.top, 50)
        .offset(x: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width > 0 {
                        dragOffset = value.translation.width
                    }
                }
                .onEnded { value in
                    if value.translation.width > 150 {
                        withAnimation {
                            showDetail = false
                        }
                    } else {
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
}

#Preview {
    NotificationsListView(showDetail: .constant(true))
}


struct CustomToggleNotifView: View {
    @Binding var isActive: Bool

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
                Image(isActive ? .iconNotifs : .moonStars)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.white)
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
