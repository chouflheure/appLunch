
import SwiftUI

struct AttendingGuestsView: View {
    @State var selection = 1
    var body: some View {
        VStack {
            HStack {
                Image(.iconArrow)
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                    .padding(.leading, 16)
                Spacer()
                Text("Invités")
                    .font(.custom("GigalypseTrial-Regular", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.trailing, 40)
            }
            .padding(.top, 100)
            
            HStack {
                Spacer()
                
                Button(action: {}) {
                    Text("✨tous")
                        .foregroundColor(.white)
                }
                Spacer()
                
                Button(action: {}) {
                    Text("👍")
                        .font(.system(size: 12))
                    Text("là")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("🤔")
                        .font(.system(size: 12))
                    Text("savent pas")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("👎")
                        .font(.system(size: 12))
                    Text("savent pas")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            
            
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        AttendingGuestsView()
    }.ignoresSafeArea()
    
}


struct PageView<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    @Binding private var selection: SelectionValue
    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode
    private let indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode
    private let content: () -> Content

    init(
        selection: Binding<SelectionValue>,
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
        indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.indexDisplayMode = indexDisplayMode
        self.indexBackgroundDisplayMode = indexBackgroundDisplayMode
        self.content = content
    }

    var body: some View {
        TabView(selection: $selection) {
            content()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: indexDisplayMode))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: indexBackgroundDisplayMode))
    }
}

extension PageView where SelectionValue == Int {
    init(
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
        indexBackgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = .constant(0)
        self.indexDisplayMode = indexDisplayMode
        self.indexBackgroundDisplayMode = indexBackgroundDisplayMode
        self.content = content
    }
}


struct ContentViewTest: View {
    @State var selection = 1

    var body: some View {
        VStack {
            Text("Selection: \(selection)")
            PageView(selection: $selection, indexBackgroundDisplayMode: .always) {
                ForEach(0 ..< 3, id: \.self) {
                    Text("Page \($0)")
                        .tag($0)
                }
            }
        }
    }
}

#Preview {
    ContentViewTest()
}
