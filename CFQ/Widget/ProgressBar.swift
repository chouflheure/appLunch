import SwiftUI

struct ProgressBar: View {
    @Binding var index: Int

    private var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 15)
                .foregroundColor(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(Color.white, lineWidth: 0.5)
                )
        
            Rectangle()
                .frame(maxWidth: screenWidth * (Double(index)+1)/4 - 20)
                .frame(height: 15)
                .foregroundColor(.white)
                .cornerRadius(50)
        }.padding()
    }
}



private struct ParentView: View {
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            ProgressBar(index: $currentIndex) // Passer la liaison à ProgressBar
        }
    }
}

#Preview {
    ParentView()
}
