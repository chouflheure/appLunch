
import SwiftUI

struct NavigationBackIcon: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 0) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                }
                .foregroundColor(.white)
                .frame(width: 70, height: 50)
            }
        }
    }
}
