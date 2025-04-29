
import SwiftUI
import StoreKit

struct PopUpAskMarkView: View {
    @Environment(\.requestReview) var requestReview

    var body: some View {
        Button("request Review") {
            requestReview()
        }
    }
}
