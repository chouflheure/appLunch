import SwiftUI

struct FriendProfileView: View {
    var isUserProfile: Bool = true

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"],
        friends: ["77MKZdb3FJX8EFvlRGotntxk6oi1"],
        isPrivateAccount: false
    )
    
    var profileFriend = User(
        uid: "77MKZdb3FJX8EFvlRGotntxk6oi1",
        name: "Profile",
        firstName: "Friend",
        pseudo: "Charles",
        location: ["Ici"],
        isPrivateAccount: true
    )

    @StateObject var viewModel = FriendProfileViewModel()

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                HStack(alignment: .center) {
                    Button(
                        action: {},
                        label: {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        })
                    Spacer()
                    Button(
                        action: {
                            viewModel.isShowingSettingsView = true
                        },
                        label: {
                            Image(.iconDots)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        })
                }
                .padding(.trailing, 12)
                .padding(.bottom, 32)
                
                HStack {
                    CirclePictureStatus(isActive: true)
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 12)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        PreviewPseudoName(
                            name: profileFriend.name,
                            firstName: profileFriend.firstName,
                            pseudo: profileFriend.pseudo
                        )
                        
                        HStack(alignment: .center) {
                            Image(.iconLocation)
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                            Text("\(profileFriend.location)")
                                .tokenFont(.Body_Inter_Medium_16)
                        }
                    }
                    Spacer()
                    
                    if !viewModel.isRequestedToBeFriendByTheUser {
                        Button(
                            action: {
                                viewModel.onclickAddFriend()
                            },
                            label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(viewModel.statusFriend.backgroungColorIcon)
                                    
                                    Image(viewModel.statusFriend.icon)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.statusFriend.strokeColor, lineWidth: 0.5)
                                                .frame(width: 44, height: 44)
                                        }
                                }
                            })
                    }
                }
                .padding(.bottom, 16)

                if viewModel.isRequestedToBeFriendByTheUser {
                    HStack {
                        Text("\(profileFriend.pseudo) te demande en ami")
                            .tokenFont(.Title_Gigalypse_20)
                        Spacer()
                        Button(
                            action: {
                                viewModel.becomeFriend(answer: true)
                            },
                            label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(viewModel.statusFriend.backgroungColorIcon)

                                    Image(.iconAccept)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(viewModel.statusFriend.strokeColor, lineWidth: 0.5)
                                                .frame(width: 44, height: 44)
                                        }
                                }
                            })
                        Button(
                            action: {
                                viewModel.becomeFriend(answer: false)
                            },
                            label: {
                                ZStack {
                                    Rectangle()
                                        .frame(width: 44, height: 44)
                                        .cornerRadius(10)
                                        .foregroundColor(.clear)
                                    Image(.iconCross)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.white, lineWidth: 0.5)
                                                .frame(width: 44, height: 44)
                                        }
                                }
                            })
                    }
                }

                if viewModel.isPrivateAccount && profileFriend.isPrivateAccount {
                    Spacer()
                    VStack {
                        Image(.iconLock)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .padding(.bottom, 16)
                            .foregroundColor(.white)
                        
                        Text("COMPTE PRIVÉ")
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                    Spacer()
                } else {
                    PageViewEventFriends()
                }
            }
            .padding(.horizontal, 16)
            
            .sheet(isPresented: $viewModel.isShowingSettingsView) {
                ZStack {
                    Color.black
                        .ignoresSafeArea()
                    
                    Text("@@@ test")
                        .foregroundColor(.white)
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(300)])
            }
        }
        .blur(radius: viewModel.isShowRemoveFriends ? 10 : 0)
        .allowsHitTesting(!viewModel.isShowRemoveFriends)
        
        if viewModel.isShowRemoveFriends {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        viewModel.isShowRemoveFriends = false
                    }
                }
                .zIndex(1)

            PopUpRemoveFromFriends(
                showPopup: $viewModel.isShowRemoveFriends,
                viewModel: viewModel
            )
            .zIndex(2)
        }
    }
}

struct PopUpRemoveFromFriends: View {
    @Binding var showPopup: Bool
    @StateObject var viewModel: FriendProfileViewModel

    var body: some View {
        ZStack() {
            VStack(spacing: 20) {
                Text("On retire de tes amis ?")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .center) {
                    Button(action: {
                        withAnimation {
                            showPopup = false
                            viewModel.statusFriend = .friend
                        }
                    }, label: {
                        Text("Non garder")
                            .tokenFont(.Label_Gigalypse_12)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing), lineWidth: 5)
                                    .frame(width: 130, height: 40)
                            }
                    })

                    Spacer()

                    Button(action: {
                        withAnimation {
                            viewModel.statusFriend = .noFriend
                            showPopup = false
                        }
                    }, label: {
                        Text("Yes, retirer")
                            .tokenFont(.Label_Gigalypse_12)
                    })
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
            }
            .frame(width: 300, height: 200)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)

            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purpleText)
                    .shadow(radius: 10)

                Image(.iconBye)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .offset(x: 0, y: 15)
            }
            .offset(y: -110)
            .zIndex(3)
        }
    }
}


struct PageViewEventFriends: View {
    @State private var selectedIndex = 0
    let titles = ["TURNs", "CALENDRIER"]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            TabView(selection: $selectedIndex) {
                Text(StringsToken.Profile.NoTurnAtThisMoment)
                    .foregroundColor(.white)
                    .tag(0)
                Text(StringsToken.Profile.NoTurnAtThisMoment)
                    .foregroundColor(.white)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

private struct HeaderProfileFriend: View {
    var body: some View {
        HStack(alignment: .center) {
            Button(
                action: {},
                label: {
                    Image(.iconArrow)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                })
            Spacer()
            Button(
                action: {},
                label: {
                    Image(.iconDots)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                })
        }
    }
}

private struct HeaderProfileUser: View {
    var viewModel: ProfileViewModel

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Button(
                action: {
                    viewModel.isShowingSettingsView = true
                },
                label: {
                    Image(.iconParametres)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                })
        }
    }
}

#Preview {
    ZStack {
        Color.black
        FriendProfileView()
    }.ignoresSafeArea()
}
