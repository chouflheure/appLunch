
import SwiftUI

struct MoodView: View {
    var moodData: MoodData

    var body: some View {
        HStack {
            Image(uiImage: moodData.icon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
            Text(moodData.title)
                .foregroundColor(.white)
                .font(.system(size: 20))
        }
    }
}
