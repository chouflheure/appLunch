
import SwiftUI
import MapKit


struct CustomTabView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @State private var selectedEvent: MapLocationEventData? = nil
    @State private var isShowPopUp: Bool = true

    @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool = false

    @State var text = ""
    @State private var zIndexOnboarding: Double = 100
    
    var body: some View {
        NavigationStack {
            SafeAreaContainer {
                ZStack {

                    if !hasAlreadyOnboarded {
                        OnboardingView() {
                            withAnimation {
                                zIndexOnboarding = 0
                             }
                        }
                        .zIndex(zIndexOnboarding)
                    }

                    if coordinator.dataApp.version != appVersion && coordinator.dataApp.isNeedToUpdateApp {
                        PopUpMAJView()
                            .zIndex(99)
                    }
                    else {
                        VStack(spacing: 0) {
                            Group {
                                if coordinator.selectedTab == 0 {
                                    FeedView(coordinator: coordinator)
                                } else if coordinator.selectedTab == 1 {
                                    Text("Coming soon")
                                        .tokenFont(.Title_Gigalypse_24)
                                } else if coordinator.selectedTab == 2 {
                                    TurnListScreen(coordinator: coordinator)
                                } else if coordinator.selectedTab == 3 {
                                    //Text("Coming soon")
                                      //  .tokenFont(.Title_Gigalypse_24)
                                    TeamView(coordinator: coordinator)
                                } else {
                                    ProfileView(coordinator: coordinator)
                                }
                            }
                            .frame(maxHeight: .infinity)
                            
                            CustomTabBarView(coordinator: coordinator)
                        }
                        .fullScreenCover(isPresented: $coordinator.showMapFullScreen) {
                            TestMap(selectedEvent: $selectedEvent, coordinator: coordinator)
                        }
                    }
                }
            }
        }
    }
}

// Extraction de la barre de navigation dans une vue séparée
struct CustomTabBarView: View {
    @ObservedObject var coordinator: Coordinator
    
    var body: some View {
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
}

/*
struct CustomTabView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    @State private var selectedEvent: MapLocationEventData? = nil
    @State private var isShowPopUp: Bool = true

    @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @AppStorage("hasAlreadyOnboarded") var hasAlreadyOnboarded: Bool = false

    @State var text = ""
    
    @State private var zIndexOnboarding: Double = 100
    
    var body: some View {
        SafeAreaContainer {
            ZStack {

                if !hasAlreadyOnboarded {
                    OnboardingView() {
                        withAnimation {
                            zIndexOnboarding = 0
                         }
                    }
                    .zIndex(zIndexOnboarding)
                }

                if coordinator.dataApp.version != appVersion && coordinator.dataApp.isNeedToUpdateApp {
                    PopUpMAJView()
                        .zIndex(99)
                }

                else {
                    VStack(spacing: 0) {
                        Group {
                            if coordinator.selectedTab == 0 {

                                // FeedView(coordinator: coordinator)
                                FeedView_Nav(coordinator: coordinator)
                                
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
            // TODO: - Update : https://claude.ai/chat/e9ddf0dd-c34f-466d-b385-54249198efd4
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

                    if coordinator.showNotificationScreen {
                        NotificationScreenView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showFriendListScreen {
                        AddFriendsScreen(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showCFQForm {
                        CFQFormView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showProfileFriend {
                        FriendProfileView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showMessageScreen {
                        ConversationsView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showTurnFeedDetail {
                        TurnCardDetailsFeedView(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }
                    
                    if coordinator.showFriendInCommum {
                        FriendCommumScreen(coordinator: coordinator)
                            .transition(.move(edge: .trailing))
                    }

                    if coordinator.showMessagerieScreen {
                        MessagerieView(
                            isPresented: $coordinator.showMessagerieScreen,
                            coordinator: coordinator,
                            conversation: coordinator.selectedConversation ?? Conversation(uid: "", titleConv: "", pictureEventURL: "", typeEvent: "", eventUID: "", lastMessageSender: "", lastMessageDate: Date(), lastMessage: "", messageReader: [])
                        )
                        .transition(.move(edge: .trailing))
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
*/
