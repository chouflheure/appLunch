
import SwiftUI

struct OnboardingPreviewSettingsView: View {
    @Binding var showDetail: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            OnboardingView(onFinish: close)
        }
    }

    func close() {
        withAnimation {
            showDetail = false
        }
    }
}
