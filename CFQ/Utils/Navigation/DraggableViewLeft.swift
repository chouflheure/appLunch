
import SwiftUI

struct DraggableViewLeft<Content: View>: View {
    @Binding var isPresented: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var isDraggingAllowed: Bool = false
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        content
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.x <= 100 {
                            isDraggingAllowed = true
                        }
                        if isDraggingAllowed {
                            if value.translation.width > 0 {
                                dragOffset = value.translation.width
                            }
                        }
                    }
                    .onEnded { value in
                        if isDraggingAllowed {
                            if value.translation.width > 150 {
                                withAnimation {
                                    isPresented = false
                                }
                            } else {
                                withAnimation {
                                    dragOffset = 0
                                }
                            }
                        }
                        isDraggingAllowed = false // Reset pour le prochain drag
                    }
            )
    }
}
