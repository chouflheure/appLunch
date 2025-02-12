import SwiftUI

enum TextFieldType {
    case sign
    case turn
    case cfq
    
    var data: TextFieldData {
        switch self {
        case .sign, .cfq:
            return TextFieldData(
                background: .black,
                foregroundColor: .white,
                hasStoke: true,
                titleCase: .lowercase,
                titleCaseFunc: { $0.lowercased() }
            )
        case .turn:
            return TextFieldData(
                background: .clear,
                foregroundColor: .purple,
                hasStoke: false,
                titleCase: .uppercase,
                titleCaseFunc: { $0.uppercased() }
            )
        }
    }
}

struct TextFieldData {
    let background: Color
    let foregroundColor: Color
    let hasStoke: Bool
    let titleCase: Text.Case
    let titleCaseFunc: (String) -> String
}

struct CustomTextField: View {
    @Binding var text: String
    let keyBoardType: UIKeyboardType
    let placeHolder: String
    let textFieldType: TextFieldType
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(when: text.isEmpty) {
                Text(placeHolder)
                    .foregroundColor(.gray)
                    .textCase(textFieldType.data.titleCase)
        }.onChange(of: text) { newValue in
            text = textFieldType.data.titleCaseFunc(newValue)
        }
        .foregroundColor(.white)
        .padding(.all, textFieldType.data.hasStoke ? 12 : 0)
        .background(textFieldType.data.background)
        .cornerRadius(8)
        .keyboardType(keyBoardType)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white, lineWidth: textFieldType.data.hasStoke ? 0.5 : 0)
        )
    }
}

private struct ParentView: View {
    @State private var currentIndex = ""
    @State private var currentIndex2 = ""

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                CustomTextField(
                    text: $currentIndex,
                    keyBoardType: .default,
                    placeHolder: "test",
                    textFieldType: .sign
                )
                CustomTextField(
                    text: $currentIndex2,
                    keyBoardType: .default,
                    placeHolder: "test",
                    textFieldType: .turn
                )
            }
        }
    }
}

#Preview {
    ParentView()
}
