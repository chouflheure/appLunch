
import SwiftUI

struct PreviewProfile: View {
    var pictures: [String]
    var previewProfileType: PreviewProfileType
    var numberUsers: Int

    var body: some View {
        HStack {
            PreviewMultiplePicture(pictures: ["https://firebasestorage.googleapis.com/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2F09D86E76-AE5A-41F7-B628-78A419169862.jpg?alt=media&token=0fbcf79d-64ec-4cfa-8a9c-2dc4cac4a093", "https://firebasestorage.googleapis.com/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2F11FB0171-140E-4D55-A1AC-902DEEBBA6DF.jpg?alt=media&token=cfae55d3-4e5c-470b-ad12-738621f1abcd"])
            Text("\(numberUsers)")
                .foregroundStyle(.white)
                .bold()
            Text(previewProfileType.rawValue)
                .foregroundStyle(.white)
        }
    }
}


struct PreviewProfileUID: View {
    var pictures: [String]
    var previewProfileType: PreviewProfileType
    var numberUsers: Int

    var body: some View {
        HStack {
            PreviewMultiplePicture(pictures: ["https://firebasestorage.googleapis.com/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2F09D86E76-AE5A-41F7-B628-78A419169862.jpg?alt=media&token=0fbcf79d-64ec-4cfa-8a9c-2dc4cac4a093", "https://firebasestorage.googleapis.com/v0/b/cfq-dev-7c39a.firebasestorage.app/o/images%2F11FB0171-140E-4D55-A1AC-902DEEBBA6DF.jpg?alt=media&token=cfae55d3-4e5c-470b-ad12-738621f1abcd"])
            Text("\(numberUsers)")
                .foregroundStyle(.white)
                .bold()
            Text(previewProfileType.rawValue)
                .foregroundStyle(.white)
        }
    }
}
