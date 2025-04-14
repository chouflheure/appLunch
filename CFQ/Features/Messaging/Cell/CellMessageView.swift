
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
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            dragOffset = value.translation.width
                            print("@@@ drag max")
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -150 {
                            withAnimation {
                                // isPresented = false
                                dragOffset = 0
                            }
                        } else {
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                    }
            )
    }
}




struct CellMessageView: View {
    @State private var dragOffset: CGFloat = 0
    @State private var showReaction: Bool = false
    var emojies = ["😘", "😀", "😆", "😅", "😄", "😃", "😋", "😂", "❤️" ]
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                ReponseMessage {
                    
                    Text("Charles")
                        .tokenFont(.Placeholder_Inter_Regular_14)
                        .padding(.leading, 50)
                    
                    HStack(alignment: .top) {
                        Image(.header)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                        
                        
                        Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ")
                            .tokenFont(.Body_Inter_Medium_12)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.blackLight)
                            .cornerRadius(20)
                            .onLongPressGesture(perform: {
                                print("@@@ tap")
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
                        Text("❤️ 😘 2")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.blackLight)
                            .cornerRadius(20)
                            .overlay() {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 0.3)
                                    .foregroundColor(.black)
                            }
                            .onTapGesture {
                                print("@@@ ")
                            }
                    }
                    .padding(.trailing, 60)
                    .offset(y: -12)
                }

                ReponseMessage {
                    HStack(alignment: .top) {
                        Text("Chaud d’un verre dans le 18 💩")
                            .tokenFont(.Body_Inter_Medium_12)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.blackLight)
                            .cornerRadius(20)
                            .onLongPressGesture(perform: {
                                print("@@@ tap")
                            })
                    }
                    .padding(.leading, 40)
                    .padding(.trailing, 30)
                }
            }
            .blur(radius: showReaction ? 10 : 0)
            .allowsHitTesting(!showReaction)
            
            if showReaction {
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
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<9) { index in
                                    Button(emojies[index]) {
                                        print("click on \(emojies[index])")
                                    }
                                }
                                Button(action: {}) {
                                    Image(.iconPlus)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.blackLight)
                            .cornerRadius(20)
                            .padding(.bottom, 5)
                        }
                        
                        Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂")
                            .tokenFont(.Body_Inter_Medium_12)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.blackLight)
                            .lineLimit(10)
                            .cornerRadius(20)
                            .onLongPressGesture(perform: {
                                print("@@@ tap")
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
        .ignoresSafeArea()
    }
}


struct ReactionMessageView {
    var body: some View {
        Text("")
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        CellMessageView()
    }
}
