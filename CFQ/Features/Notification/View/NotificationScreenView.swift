
import SwiftUI

struct NotificationScreenView: View {
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showNotificationScreen) {
            SafeAreaContainer {
                VStack {
                    HStack(alignment: .center) {
                        Button(
                            action: {
                                withAnimation {
                                    coordinator.showNotificationScreen = false
                                }
                            },
                            label: {
                                Image(.iconArrow)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            })
                        Spacer()
                        
                        Text("NOTIFICATIONS")
                            .tokenFont(.Title_Gigalypse_24)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)

                    Divider()
                        .frame(height: 0.5)
                        .background(.white)
                        .padding(.bottom, 15)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Aujourd'hui")
                                .tokenFont(.Body_Inter_Medium_16)
                                .padding(.horizontal, 12)
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                            
                            Text("Hier")
                                .tokenFont(.Body_Inter_Medium_16)
                                .padding(.horizontal, 12)
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                            CellRequestAction()
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    SafeAreaContainer {
        NotificationScreenView(coordinator: Coordinator())
    }
}
