
import SwiftUI

struct TabButton: View {
    let iconUnselected: ImageResource
    let iconSelected: ImageResource
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(isSelected ? iconSelected : iconUnselected)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}
