import SwiftUI

struct ConversationsView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: PreviewMessagerieScreenViewModel
    @State private var showDetail = false
    @State private var showDetailPopUp = false

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: PreviewMessagerieScreenViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showMessageScreen) {
            SafeAreaContainer {
                VStack(spacing: 0) {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                coordinator.showMessageScreen = false
                            }
                        },
                        titleScreen: StringsToken.Messaging.titleScreen
                    )
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer()
                            .frame(height: 12)
                        VStack(alignment: .leading) {
                            SearchBarView(
                                text: $viewModel.researchText,
                                placeholder: StringsToken.SearchBar
                                    .placeholderConversation,
                                onRemoveText: {
                                    // viewModel.removeText()
                                },
                                onTapResearch: {
                                    // viewModel.researche()
                                }
                            ).padding(.top, 16)

                            ForEach(viewModel.messageList.sorted { $0.lastMessageDate ?? Date() > $1.lastMessageDate ?? Date() }, id: \.uid) {
                                data in
                                CellMessagingView(data: data, hasUnReadMessage: !data.messageReader.contains(coordinator.user?.uid ?? "")) { _ in
                                    coordinator.selectedConversation = data
                                    withAnimation {
                                        showDetail = true
                                    }
                                }.padding(.top, 16)
                            }.padding(.horizontal, 16)
                        }
                    }

                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }

        if showDetail {
            destinationView()
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        MessagerieView(isPresented: $showDetail, coordinator: coordinator)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        ConversationsView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
