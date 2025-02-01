//
//  TabBar.swift
//  CFQ
//
//  Created by Calvignac Charles on 21/01/2025.
//
import SwiftUI

struct CustomPlusButton: View {
    var body: some View {
        ZStack {

            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue.opacity(0.4)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .blur(radius: 1, opaque: true)
                .cornerRadius(10)
                .frame(width: 55, height: 55)

            Rectangle()
                .foregroundColor(.black)
                .cornerRadius(10)
                .frame(width: 50, height: 50)
                .shadow(radius: 30)

            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct CustomTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Image(.backgroundNeon)
                .resizable()
                .ignoresSafeArea()
            VStack {
                Group {
                    if selectedTab == 0 {
                        // SignScreen()
                         Text("Feed")
                            .foregroundStyle(.white)
                    } else if selectedTab == 1 {
                        Text("Maps Screen")
                            .foregroundStyle(.white)
                    } else if selectedTab == 2 {
                        TurnCardView()
                    } else if selectedTab == 3 {
                        Test()
                    } else {
                        Text("Profile Screen")
                            .foregroundStyle(.white)
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

                    CustomPlusButton()
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
        }
    }
}

struct TabButton: View {
    let iconUnselected: ImageResource
    let iconSelected: ImageResource
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(isSelected ? iconSelected : iconUnselected)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}


#Preview {
    CustomTabView()
}
