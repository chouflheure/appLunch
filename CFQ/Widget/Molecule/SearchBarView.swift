
import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var placeholder: String
    var onRemoveText: (() -> Void)
    var onTapResearch: (() -> Void)
    
    var body: some View {
        CustomTextField(
            text: $text,
            keyBoardType: .default,
            placeHolder: placeholder,
            textFieldType: .searchBar,
            onRemoveText: {
                onRemoveText()
            },
            onTapResearch: {
                onTapResearch()
            }
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    SafeAreaContainer {
        SearchBarView(text: .constant(""), placeholder: StringsToken.SearchBar.placeholderFriend, onRemoveText: {}, onTapResearch: {})
    }
}
