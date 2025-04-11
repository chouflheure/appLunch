
import SwiftUI

struct MessageScreenView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel = MessageScreenViewModel()

    var body: some View {
        DraggableView(isPresented: $isPresented) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                isPresented = false
                            }
                        },
                        titleScreen: "Messagerie"
                    )
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            SearchBarView(
                                text: $viewModel.researchText,
                                placeholder: "Recherche une conv",
                                onRemoveText: {
                                    viewModel.removeText()
                                },
                                onTapResearch: {
                                    viewModel.researche()
                                }
                            ).padding(.top, 16)
                            
                            ForEach(Array(viewModel.messageList), id: \.self) { data in
                                CellMessagingView(data: data)
                                    .padding(.top, 16)
                            }.padding(.horizontal, 16)
                        }
                    }
                    
                    
                }
            }
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        MessageScreenView(isPresented: .constant(true))
    }.ignoresSafeArea()
}
