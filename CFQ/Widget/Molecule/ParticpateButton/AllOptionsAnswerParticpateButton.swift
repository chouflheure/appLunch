import SwiftUI

struct AllOptionsAnswerParticpateButton: View {
    @Binding var participateButtonSelected: TypeParticipateButton

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    AnswerParticpateButton(
                        typeParticipateButton: .maybe,
                        isSelected: participateButtonSelected == .maybe
                    ) {
                        participateButtonSelected = .maybe
                    }
                    
                    AnswerParticpateButton(
                        typeParticipateButton: .yes,
                        isSelected: participateButtonSelected == .yes
                    ) {
                        participateButtonSelected = .yes
                    }
                    .offset(y: -60)
                    
                    AnswerParticpateButton(
                        typeParticipateButton: .no,
                        isSelected: participateButtonSelected == .no
                    ) {
                        participateButtonSelected = .no
                    }
                }
                .frame(height: 200)
            }
        }
    }
}

