
import SwiftUI

struct NavgitationBackIcon: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
            }
            .foregroundColor(.white)
        }
    }
}
