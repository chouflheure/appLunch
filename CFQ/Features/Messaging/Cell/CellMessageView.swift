import SwiftUI

struct ReponseMessage<Content: View>: View {
    @State private var dragOffset: CGFloat = 0
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .offset(x: dragOffset)
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        if abs(value.translation.width)
                            > abs(value.translation.height)
                        {
                            if value.translation.width > 0 {
                                dragOffset = value.translation.width
                            }
                        }
                    }
                    .onEnded { value in
                        if abs(value.translation.width)
                            > abs(value.translation.height)
                        {
                            if value.translation.width > 150 {
                                withAnimation {
                                    dragOffset = 0
                                }
                            } else {
                                withAnimation {
                                    dragOffset = 0
                                }
                            }
                        }
                    }
            )
    }
}

struct EmojiView: View {
    let emojies = ["😘", "😀", "😆", "😅", "😄", "😃", "😋", "😂", "❤️"]
    var onTapOnEmojie: ((String) -> Void)

    @State private var visibleIndexes: Set<Int> = []
    var dureactionAnimation = 0.02

    var body: some View {
        HStack {
            ForEach(0..<emojies.count, id: \.self) { index in
                Text(emojies[index])
                    .font(.system(size: 15))
                    .opacity(visibleIndexes.contains(index) ? 1 : 0)
                    .offset(y: visibleIndexes.contains(index) ? 0 : -20)  // 👈 chute du haut
                    .animation(
                        .easeOut(duration: 0.4).delay(
                            Double(index) * dureactionAnimation),
                        value: visibleIndexes
                    )
                    .onTapGesture {
                        onTapOnEmojie(emojies[index])
                    }
            }
            Button(action: {

            }) {
                Image(.iconPlus)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.white)
                    .frame(width: 15, height: 15)
            }
        }
        .onAppear {
            for index in emojies.indices {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + Double(index) * dureactionAnimation
                ) {
                    visibleIndexes.insert(index)
                }
            }
        }
    }
}

struct CellMessageView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var showReaction: Bool = false
    @State private var isShowPopover = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack(alignment: .leading) {

                    // ReponseMessage {

                    Text("Charles")
                        .tokenFont(.Placeholder_Inter_Regular_14)
                        .padding(.leading, 50)

                    HStack(alignment: .top) {
                        Image(.header)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())

                        Text(
                            "Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le "
                        )
                        .tokenFont(.Body_Inter_Medium_12)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.blackLight)
                        .cornerRadius(20)
                        .onLongPressGesture(perform: {

                        })
                        .onTapGesture(count: 2) {
                            withAnimation {
                                showReaction = true
                            }
                        }
                    }
                    .padding(.trailing, 30)

                    HStack {
                        Spacer()
                        Button(action: {
                            isShowPopover = true
                        }) {
                            Text("❤️ 😘 2")
                                .foregroundColor(.white)
                                .font(.system(size: 10))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(.blackLight)
                                .cornerRadius(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 0.3)
                                        .foregroundColor(.black)
                                }
                                .popover(
                                    isPresented: $isShowPopover,
                                    arrowEdge: .bottom,
                                    content: {
                                        Text("Hello, World!")
                                            .padding()
                                            .presentationCompactAdaptation(
                                                .none)
                                    }
                                )
                                .zIndex(999)
                        }
                    }
                    .padding(.trailing, 60)
                    .offset(y: -12)

                    // }

                }
                .blur(radius: showReaction ? 10 : 0)
                .allowsHitTesting(!showReaction)

                if showReaction {
                    ReactionPreviewView(showReaction: $showReaction)
                }
            }
            .ignoresSafeArea()
        }
    }
}


struct ReactionPreviewView: View {
    @Binding var showReaction: Bool

    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation {
                    showReaction = false
                }
            }
            .zIndex(1)

        HStack(alignment: .top) {
            VStack {
                EmojiView { emojie in
                    print("@@@ emojie tap = \(emojie)")
                    withAnimation {
                        showReaction = false
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.blackLight)
                .cornerRadius(20)
                .padding(.bottom, 5)
                .frame(alignment: .leading)

                Text(
                    "Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂"
                )
                .tokenFont(.Body_Inter_Medium_12)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.blackLight)
                .lineLimit(10)
                .cornerRadius(20)
                .onLongPressGesture(perform: {

                })
                .onTapGesture(count: 2) {
                    withAnimation {
                        // showReaction = true
                    }
                }
            }
        }

        .padding(.leading, 40)
        .padding(.trailing, 30)
        .zIndex(2)
        .ignoresSafeArea()
    }
}


struct CellMessageSendByTheUserView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var showReaction: Bool = false
    @State private var isShowPopover = false
    var data: Message
    var isSameLastSender: Bool

    var onDoubleTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .trailing, spacing: 0) {

                // ReponseMessage {
                    
                    HStack(spacing: 0) {
                        Spacer()
                        Text(data.message)
                            .tokenFont(.Body_Inter_Regular_15)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.purpleDark)
                            .cornerRadius(20)
                            .simultaneousGesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        print("@@@ long Tap")
                                        showReaction = true
                                    }
                            )
                            .simultaneousGesture(
                                TapGesture(count: 2)
                                    .onEnded {
                                        onDoubleTap()
                                        print("@@@ double Tap")
                                    }
                            )
                       
                    }

                    if data.reactions?.count ?? 0 > 0 {
                        HStack {
                            Spacer()
                            Button(action: {
                                isShowPopover = true
                            }) {
                                Text("❤️ 😘 2")
                                    .foregroundColor(.white)
                                    .font(.system(size: 10))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(.blackLight)
                                    .cornerRadius(20)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 0.3)
                                            .foregroundColor(.black)
                                    }
                                    .popover(
                                        isPresented: $isShowPopover,
                                        arrowEdge: .bottom,
                                        content: {
                                            Text("Hello, World!")
                                                .padding()
                                                .presentationCompactAdaptation(
                                                    .none)
                                        }
                                    )
                                    .zIndex(999)
                            }
                            
                        }
                        .padding(.trailing, 20)
                        .offset(y: -12)
                    }
                }

            }
            .padding(.trailing, 15)
            .padding(.leading, 30)
            .padding(.top, isSameLastSender ? 0 : 15)
        // }
    }
}

struct CellMessageViewReceived: View {
    @State private var dragOffset: CGFloat = 0
    @State private var showReaction: Bool = false
    @State private var isShowPopover = false
    
    var data: Message
    var isSameLastSender: Bool
    
    var body: some View {
        // ReponseMessage {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom, spacing: 8) {
                Group {
                    if !isSameLastSender {
                        CachedAsyncImageView(
                            urlString: data.userContact?.profilePictureUrl ?? "",
                            designType: .scaleImageMessageProfile
                        )
                    } else {
                        Spacer()
                            .frame(width: 50)
                    }
                }
                
                // Container du nom + message
                VStack(alignment: .leading, spacing: 4) {
                    // Nom de l'utilisateur
                    if !isSameLastSender {
                        Text(data.userContact?.pseudo ?? "User")
                            .tokenFont(.Placeholder_Inter_Regular_14)
                            .padding(.leading, 5)
                    }
                    
                    // Bulle de message
                    Text(data.message)
                        .tokenFont(.Body_Inter_Regular_15)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(.blackLight)
                        .cornerRadius(20)
                }
                
                Spacer()
                    
            }
        }
        .padding(.horizontal, 5)
        .padding(.top, isSameLastSender ? 0 : 15)
    }
// }
}

#Preview {
    CellMessageViewReceived(data: Message(uid: "", message: "Coucou les filles ! Je vous confirme que Joséphine sera au bureau vendredi pour aller la chercher !", senderUID: "", timestamp: Date()), isSameLastSender: false)
    CellMessageViewReceived(data: Message(uid: "", message: "Coucou les filles ! Je vous confirme que Joséphine sera au bureau vendredi pour aller la chercher !", senderUID: "", timestamp: Date()), isSameLastSender: true)
    CellMessageSendByTheUserView(data: Message(uid: "", message: "Coucou les filles ! Je vous confirme que Joséphine sera au bureau vendredi pour aller la chercher !", senderUID: "", timestamp: Date()), isSameLastSender: false, onDoubleTap: {})
    CellMessageSendByTheUserView(data: Message(uid: "", message: "Coucou les filles ! Je vous confirme que Joséphine sera au bureau vendredi pour aller la chercher !", senderUID: "", timestamp: Date()), isSameLastSender: true, onDoubleTap: {})
}
