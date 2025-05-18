
import SwiftUI

struct MoodView: View {
    var moodData: MoodData

    var body: some View {
        HStack {
            Image(uiImage: moodData.icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Text(moodData.title)
                .foregroundColor(.white)
                .tokenFont(.Body_Inter_Medium_16)
        }
    }
}
