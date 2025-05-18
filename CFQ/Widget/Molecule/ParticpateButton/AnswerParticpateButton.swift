
import SwiftUI

struct AnswerParticpateButton: View {
    var typeParticipateButton: TypeParticipateButton
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        VStack {
            Button(
                action: {
                    onTap()
                },
                label: {
                    VStack(spacing: 5) {
                        Text(typeParticipateButton.iconTypeParticipate)
                            .font(.system(size: 30, design: .default))
                        Text(typeParticipateButton.titleTypeParticipate)
                            .tokenFont(.Body_Inter_Medium_14)
                    }
                    .frame(width: 110, height: 110)
                    .overlay {
                        Circle()
                            .stroke(
                                isSelected ? .white : .gray,
                                style: StrokeStyle(lineWidth: 2)
                            )
                            .frame(width: 96, height: 96)
                    }
                }
            )
            .frame(width: 110, height: 110)
            .opacity(isSelected ? 1 : 0.5)
        }
    }
}
