
import Foundation

class MessagerieScreenViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var textMessage: String = ""

}
