
import SwiftUI
import MapKit
import FirebaseFirestore

struct CustomTabView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @State private var selectedEvent: MapLocationEventData? = nil
    @State private var isShowPopUp: Bool = true

    @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool = true

    @State var text = ""
    var body: some View {
        SafeAreaContainer {
            ZStack {

                if !hasAlreadyOnboarded {
                    OnboardingView()
                }

                if coordinator.dataApp.version != appVersion && coordinator.dataApp.isNeedToUpdateApp {
                    PopUpMAJView()
                }

                else {
                    VStack(spacing: 0) {
                        Group {
                            if coordinator.selectedTab == 0 {

                                FeedView(coordinator: coordinator)
                                
                                // CellMessageView()
                                // P158_SubscriptionView()
                            } else if coordinator.selectedTab == 1 {
                                //FriendListScreen()
                                // TestTextEditor(text: $text)
                                
                                /*
                                TestMap(
                                    selectedEvent: $selectedEvent,
                                    coordinator: coordinator
                                )
                                .offset(y: -30)
                                .padding(.bottom, -30)
                                 */
                                // ContentView8()
                                
                                Text("Map")
                                    .tokenFont(.Title_Gigalypse_24)
                                
                                // CachedImageTest()

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
                                // TurnCoreDataView()
                                
                                
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
                    /*
                    .sheet(isPresented: $coordinator.showSheetParticipateAnswers) {
                        AllOptionsAnswerParticpateButton(participateButtonSelected: .constant(.maybe))
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.height(350)])
                    }
                     */
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
                    
                    if coordinator.showTeamDetail {
                        TeamDetailView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showTeamDetailEdit {
                        TeamEditViewScreen(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showTurnCardView {
                        TurnCardView(coordinator: coordinator, coreDataViewModel: TurnCoreDataViewModel())
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showTurnFeedDetail {
                        TurnCardDetailsFeedView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showNotificationScreen {
                        NotificationScreenView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showFriendListScreen {
                        AddFriendsScreen(coordinator: coordinator)
                            .transition(.move(edge: .leading))
                    }
                    
                    if coordinator.showCFQForm {
                        CFQFormView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showMessageScreen {
                        ConversationsView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showMessagerieScreen {
                        MessagerieView(isPresented: $coordinator.showMessagerieScreen, coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showProfileFriend {
                        FriendProfileView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                            .zIndex(100)
                    }
                }
            )
            // .animation(.easeInOut, value: coordinator.showProfileFriend)
        }
    }
}

#Preview {
    CustomTabView(coordinator: .init())
}
