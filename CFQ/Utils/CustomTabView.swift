
import SwiftUI
import MapKit
import FirebaseFirestore

struct CustomTabView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @State private var selectedEvent: MapLocationEventData? = nil
    @State private var isShowPopUp: Bool = true

    // @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool = true
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: "Ici"
    )
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NeonBackgroundImage()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                if !hasAlreadyOnboarded {
                    OnboardingView()
                }

                if coordinator.dataApp.version != appVersion && coordinator.dataApp.isNeedToUpdateApp {
                    PopUpMAJView()
                }

                else {
                    VStack {
                        Group {
                            if coordinator.selectedTab == 0 {
                                FeedView(coordinator: coordinator)
                                // CellMessageView()
                                // P158_SubscriptionView()
                            } else if coordinator.selectedTab == 1 {
                                //FriendListScreen()
                                TestMap(
                                    selectedEvent: $selectedEvent,
                                    coordinator: coordinator
                                )
                                .offset(y: -30)
                                .padding(.bottom, -30)
                            } else if coordinator.selectedTab == 2 {
                                TurnListScreen(coordinator: coordinator)
                                /*
                                TurnCardView(
                                    viewModel: TurnCardViewModel(),
                                    isShow: false,
                                    select: {selected in print("Card selected \(selected)")}
                                )
                                 */
                            } else if coordinator.selectedTab == 3 {
                                TeamView(coordinator: coordinator)
                                // Screen()
                            } else {
                                ProfileView(coordinator: coordinator)
                            }
                        }
                        .frame(maxHeight: .infinity)
                        
                        HStack() {
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavHome,
                                      iconSelected: .iconNavHomeFilled,
                                      isSelected: coordinator.selectedTab == 0) {
                                coordinator.selectedTab = 0
                            }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavMap,
                                      iconSelected: .iconNavMapFilled,
                                      isSelected: coordinator.selectedTab == 1) {
                                coordinator.selectedTab = 1
                            }
                            
                            Spacer()
                            
                            CustomPlusButtonTabBar()
                                .onTapGesture {
                                    coordinator.selectedTab = 2
                                }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavTeam,
                                      iconSelected: .iconNavTeamFilled,
                                      isSelected: coordinator.selectedTab == 3) {
                                coordinator.selectedTab = 3
                            }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavProfile,
                                      iconSelected: .iconNavProfileFilled,
                                      isSelected: coordinator.selectedTab == 4) {
                                coordinator.selectedTab = 4
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical)
                        .background(.black)
                    }
                    .padding(.top, 15)// geometry.safeAreaInsets.top) // Respecte la safe area en haut
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    // .edgesIgnoringSafeArea(coordinator.selectedTab == 1 ? .all : .bottom)
                    .edgesIgnoringSafeArea(.bottom)
                    .fullScreenCover(isPresented: $coordinator.showMapFullScreen) {
                        TestMap(selectedEvent: $selectedEvent, coordinator: coordinator)
                    }
                }
            }
            .overlay(
                Group {
                    if coordinator.showCreateTeam {
                        TeamFormView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showFriendList {
                        FriendListScreen(
                            coordinator: coordinator
                        )
                        .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showProfileFriend {
                        FriendProfileView(show: $coordinator.showProfileFriend)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showTeamDetail {
                        TeamDetailView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showTeamDetailEdit {
                        TeamEditViewScreen(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showTurnCardView {
                        TurnCardView(isShow: $coordinator.showTurnCardView)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showNotificationScreen {
                        NotificationScreenView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showFriendListScreen {
                        AddFriendsScreen(isPresented: $coordinator.showFriendListScreen)
                            .transition(.move(edge: .leading))
                    }
                    
                    if coordinator.showCFQForm {
                        CFQFormView(
                            coordinator: coordinator,
                            user: user
                        )
                        .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showMessageScreen {
                        PreviewMessagerieScreenView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                }
            )
            .frame(width: geometry.size.width, height: geometry.size.height)
            .animation(.easeInOut, value: coordinator.showCreateTeam)
        }
    }
}

#Preview {
    CustomTabView(coordinator: .init())
}
