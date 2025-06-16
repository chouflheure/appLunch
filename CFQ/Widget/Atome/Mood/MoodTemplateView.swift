
import SwiftUI

struct MoodTemplateView: View {
    let icon: UIImage = .iconMoodBefore
    let title: String = "Mood(s)"

    var body: some View {
        HStack {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.gray)
                .tokenFont(.Body_Inter_Medium_16)
        }
    }
}
