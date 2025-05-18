
import SwiftUI

struct ButtonParticipate: View {
    var cornerRadius: CGFloat = 6
    var action: () -> Void
    @Binding var selectedOption: TypeParticipateButton

    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                HStack {
                    Text(selectedOption == .none ? "T'y vas ?" : selectedOption.titleTypeParticipate)
                    .tokenFont(.Label_Gigalypse_12)
                    .padding(.leading, 5)
                    .padding(.vertical, 10)
                    .padding(.trailing, 5)

                    if selectedOption == .none {
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white)
                            .padding(.trailing, 5)
                            .padding(.vertical, 10)
                    }
                }
                .frame(width: 110)
            }
        )
        .background(selectedOption == .none ? Color(hex: "B098E6") : .black)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    selectedOption == .none ? .clear : .white,
                    style: StrokeStyle(
                        lineWidth: selectedOption == .none ? 0 : 2))
        }
        .cornerRadius(10)
    }
}
