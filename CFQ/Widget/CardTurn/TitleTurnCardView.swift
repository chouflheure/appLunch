
import SwiftUI

struct TitleTurnCardView: View {
    
    // TODO: Change with user
    var userProfileImage: UIImage = .profile
    var userName: String = "Name"

    @FocusState private var isFocused: Bool
    @ObservedObject var viewModel: TurnCardViewModel

    var body: some View {
        VStack(alignment: .leading) {
            
            if viewModel.isEditing {
                CustomTextField(
                    text: $viewModel.title,
                    keyBoardType: .default,
                    placeHolder: StringsToken.TurnCardInformation.PlaceholderTitle,
                    textFieldType: .turn
                )
                .focused($isFocused)
                .padding(.bottom, 16)
                
            } else {

                Text(viewModel.title)
                    .font(.title)
                    .padding(.bottom, 16)
                    .foregroundColor(.white)
                    .bold()
                    .textCase(.uppercase)
            }

            HStack {
                Image(uiImage: userProfileImage)
                Text(userName)
                    .foregroundColor(.white)
                    .lineLimit(1)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }
                ButtonParticipate(action: {})
            }
            PreviewProfile(pictures: [], previewProfileType: .userComming)
                    .padding(.vertical, 8)
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
            .ignoresSafeArea()
        TitleTurnCardView(viewModel: TurnCardViewModel())
    }
}
