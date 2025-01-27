import SwiftUI

struct TextFieldBGBlackFull: View {
    @Binding var text: String
    let keyBoardType: UIKeyboardType
    let placeHolder: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeHolder).foregroundColor(.gray)
        }
            .foregroundColor(.white)
            .padding()
            .background(.black)
            .cornerRadius(8)
            .keyboardType(keyBoardType)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white, lineWidth: 0.5)
            )
    }
}

private struct ParentView: View {
    @State private var currentIndex = ""

    var body: some View {
        VStack {
            TextFieldBGBlackFull(
                text: $currentIndex,
                keyBoardType: .default,
                placeHolder: "test"
            )
        }
    }
}

#Preview {
    ParentView()
}
