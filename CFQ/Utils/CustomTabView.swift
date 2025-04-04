
import SwiftUI
import MapKit
import FirebaseFirestore

struct CustomTabView: View {
    @State private var selectedTab = 0
    @State private var selectedEvent: MapLocationEventData? = nil
    @EnvironmentObject var user: User

  
    @ObservedObject var coordinator: Coordinator
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool = true

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NeonBackgroundImage()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                if !hasAlreadyOnboarded {
                    OnboardingView()
                } else {
                    VStack {
                        Group {
                            if selectedTab == 0 {
                                FeedView(coordinator: coordinator)
                            } else if selectedTab == 1 {
                                //FriendListScreen()
                                Text("Map")
                                    .foregroundStyle(.white)
                            } else if selectedTab == 2 {
                                TurnCardView(
                                    viewModel: TurnCardViewModel(),
                                    isShow: false,
                                    select: {selected in print("Card selected \(selected)")}
                                )
                            } else if selectedTab == 3 {
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
                                      isSelected: selectedTab == 0) {
                                selectedTab = 0
                            }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavMap,
                                      iconSelected: .iconNavMapFilled,
                                      isSelected: selectedTab == 1) {
                                selectedTab = 1
                            }
                            
                            Spacer()
                            
                            CustomPlusButtonTabBar()
                                .onTapGesture {
                                    selectedTab = 2
                                }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavTeam,
                                      iconSelected: .iconNavTeamFilled,
                                      isSelected: selectedTab == 3) {
                                selectedTab = 3
                            }
                            
                            Spacer()
                            
                            TabButton(iconUnselected: .iconNavProfile,
                                      iconSelected: .iconNavProfileFilled,
                                      isSelected: selectedTab == 4) {
                                selectedTab = 4
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical)
                        .background(.black)
                    }
                    .padding(.top, 15)// geometry.safeAreaInsets.top) // Respecte la safe area en haut
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .overlay(
                Group {
                    if coordinator.showDetailTeam {
                        TeamFormView(showDetail: $coordinator.showDetailTeam)
                            .transition(.move(edge: .trailing))
                    }
                    if coordinator.showFriendList {
                        FriendListScreen(
                            coordinator: coordinator,
                            show: $coordinator.showFriendList
                        )
                        .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showProfileFriend {
                        FriendProfileView(show: $coordinator.showProfileFriend)
                            .transition(.move(edge: .trailing))
                    }
                }
            )
            .frame(width: geometry.size.width, height: geometry.size.height) // Évite que la vue se rétrécisse
            .animation(.easeInOut, value: coordinator.showDetailTeam)
        }
    }
}

#Preview {
    CustomTabView(coordinator: .init())
}
