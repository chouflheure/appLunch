
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
                        if value.translation.width > 0 {
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if value.translation.width > 150 {
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

import SwiftUI

struct EmojiView: View {
    let emojies = ["😘", "😀", "😆", "😅", "😄", "😃", "😋", "😂", "❤️"]
    var onTapOnEmojie: ((String) -> Void )

    @State private var visibleIndexes: Set<Int> = []
    var dureactionAnimation = 0.02

    var body: some View {
        HStack {
            ForEach(0..<emojies.count, id: \.self) { index in
                Text(emojies[index])
                    .font(.system(size: 15))
                    .opacity(visibleIndexes.contains(index) ? 1 : 0)
                    .offset(y: visibleIndexes.contains(index) ? 0 : -20) // 👈 chute du haut
                    .animation(.easeOut(duration: 0.4).delay(Double(index) * dureactionAnimation), value: visibleIndexes)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * dureactionAnimation) {
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
                                .overlay() {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(lineWidth: 0.3)
                                        .foregroundColor(.black)
                                }
                                .popover(isPresented: $isShowPopover, arrowEdge: .bottom,
                                         content: {
                                    Text("Hello, World!")
                                        .padding()
                                        .presentationCompactAdaptation(.none)
                                })
                                .zIndex(999)
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
                        
                        EmojiView() { emojie in
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
                        
                        Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂")
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
        .ignoresSafeArea()
    }
}


fileprivate
struct PopoverDetailView: View {
    var body: some View {
        Text("Popover Content")
            .padding()
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



import SwiftUI

class P158_SubscriptionView {
    
    init() {}
    @State private var count1: Double = 0
    @State private var count2: Double = 0
    
    @State private var angle1 = Angle(degrees: 0)
    @State private var angle2 = Angle(degrees: 0)
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    public var body: some View {
        ZStack {
            SubscriptionView(content:
                                StrokeCapsuleView(color: Color.purple)
                                .frame(width: 260, height: 100)
                                .rotationEffect(angle1)
                             , publisher: timer) { t in
                self.count1 += 1
                self.angle1 = Angle(degrees: self.count1 * 45)
            }
            StrokeCapsuleView(color: Color.orange)
                .frame(width: 100, height: 260)
                .rotationEffect(angle2)
                .onReceive(timer) { t in
                    self.count2 += 1
                    self.angle2 = Angle(degrees: self.count1 * -45)
                }
        }
        .animation(.easeOut, value: count1)
        .animation(.easeOut, value: count2)
    }
}

fileprivate
extension P158_SubscriptionView {
    struct StrokeCapsuleView: View {
        let color: Color
        var body: some View {
            Capsule()
                .stroke(lineWidth: 1)
                .foregroundColor(color)
        }
    }
}
/*
struct P158_SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        P158_SubscriptionView()
    }
}
*/
