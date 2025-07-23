
import SwiftUI

struct SettingsTeamDetailSheet: View {
    @ObservedObject var coordinator: Coordinator
    var isAdmin: Bool
    @Binding var isPresented: Bool
    // @StateObject var viewModel: TeamFormViewModel
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 30) {
                if isAdmin {
                    HStack {
                        Image(.iconEdit)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(height: 20)
                        Button(
                            action: {
                                Logger.log("Modifier la team", level: .action)
                                isPresented = false
                                // viewModel.showSheetSettingTeam = false
                                withAnimation {
                                    coordinator.showTeamDetailEdit = true
                                }
                            },
                            label: {
                                Text("Modifier la team")
                                    .tokenFont(.Body_Inter_Medium_16)
                            })
                        Spacer()
                    }
                }
                HStack {
                    Image(.iconTrash)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Quitter la team", level: .action)
                            isPresented = false
                            // viewModel.showSheetSettingTeam = false
                        },
                        label: {
                            Text("Quitter la team")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
                }
            }
            .padding(.leading, 12)
        }
    }
}

