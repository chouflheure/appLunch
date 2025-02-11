
import SwiftUI

struct MoodTemplateView: View {
    let icon: UIImage = .iconMoodBefore
    let title: String = "Mood"

    var body: some View {
        HStack {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.gray)
                .font(.system(size: 20))
        }
    }
}
