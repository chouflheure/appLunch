import SwiftUI

struct ConversationsView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: PreviewMessagerieScreenViewModel
    @State private var showDetail = false
    @State private var showDetailPopUp = false
    @State var messagerieType: String?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: PreviewMessagerieScreenViewModel(
                coordinator: coordinator))
    }

    var body: some View {

        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    /*
                    SearchBarView(
                        text: $viewModel.researchText,
                        placeholder: StringsToken.SearchBar.placeholderConversation,
                        onRemoveText: {
                            // viewModel.removeText()
                        },
                        onTapResearch: {
                            // viewModel.researche()
                        }
                    ).padding(.top, 16)
                    */

                    ForEach(viewModel.messageList.sorted {$0.lastMessageDate ?? Date() > $1.lastMessageDate ?? Date()}, id: \.uid ) { data in
                        NavigationLink(destination: {
                            AddFriendsScreen(coordinator: coordinator)
                        }) {
                            CellMessagingView(
                                data: data,
                                hasUnReadMessage: !data.messageReader.contains(
                                    coordinator.user?.uid ?? "")
                            )
                            /*{ _ in
                                coordinator.selectedConversation = data
                                withAnimation {
                                    messagerieType = data.typeEvent
                                    showDetail = true
                                }
                             }*/ .padding(.bottom, 16)
                        }
                    }.padding(.horizontal, 16)
                }
            }

        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .customNavigationFlexible(
            leftElement: {
                NavgitationBackIcon()
            },
            centerElement: {
                NavgitationTitle(title: "Messagerie")
            },
            rightElement: { EmptyView() }
        )

        if showDetail {
            destinationView()
                .transition(.move(edge: .trailing))
                .zIndex(1)
        }
    }

    @ViewBuilder
    func destinationView() -> some View {
        MessagerieView(
            isPresented: $showDetail, coordinator: coordinator,
            conversation: coordinator.selectedConversation!)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        ConversationsView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
