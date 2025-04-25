
import SwiftUI

struct NotificationsListView: View {
    @Binding var showDetail: Bool
    @State private var notificationType = NotificationType.allCases
    @StateObject var viewModel = NotificationsListViewModel()

    var body: some View {
        DraggableViewLeft(isPresented: $showDetail) {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                showDetail = false
                            }
                        }, titleScreen: StringsToken.Settings.headerNotifications
                    )

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
                    .padding(.horizontal, 12)
                }
            }
        }
        .padding(.top, 50)
    }
}

#Preview {
    NotificationsListView(showDetail: .constant(true))
}

