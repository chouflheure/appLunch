import SwiftUI

enum MessagerieHeaderType {
    case cfq
    case people
    case event
}

struct MessagerieScreenView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = MessagerieScreenViewModel()
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Image(.iconArrow)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                }

                Spacer()

                CFQMolecule(name: "Charles", title: "CFQ Demain")

                Spacer()

                Button(action: {

                }) {
                    Image(.iconGuests)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24)
                }.padding(.trailing, 16)

                Button(action: {
                    viewModel.showSettingMessagerie = true
                }) {
                    Image(.iconDots)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 24)
                }
            }.padding(.horizontal, 12)
            
            Divider()
                .background(.white)
            
            
                
        }
        .sheet(isPresented: $viewModel.showSettingMessagerie) {
            SettingMessagerieSheet(
                viewModel: viewModel
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])

        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        MessagerieScreenView(isPresented: .constant(true))
    }
}

private struct SettingMessagerieSheet: View {
    @StateObject var viewModel: MessagerieScreenViewModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 30) {
                HStack {
                    Image(.iconAdduser)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Ajouter des membres", level: .action)
                            viewModel.showSettingMessagerie = false
                        },
                        label: {
                            Text("Ajouter des membres")
                                .tokenFont(.Body_Inter_Medium_16)
                        })

                    Spacer()
                }

                HStack {
                    Image(.iconCrown)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Edit Admin", level: .action)
                            viewModel.showSettingMessagerie = false
                        },
                        label: {
                            Text("Modifier les admins")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
                }

                HStack {
                    Image(.iconEdit)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20)
                    Button(
                        action: {
                            Logger.log("Modifier la team", level: .action)
                            viewModel.showSettingMessagerie = false
                        },
                        label: {
                            Text("Modifier la team")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
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
                            viewModel.showSettingMessagerie = false
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
