
import Foundation

class MessagerieScreenViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var showConversationOptionView: Bool = false

    @Published var textMessage: String = ""
    @Published var messages: [String] = [
        "Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ",
        "Vasy Go",
        "c'est mort c'est null comme coin",
        "Ouais bien d'accord, pas ouf .. 😅",
        "On parle de quoi je n'ai pas lu les messages précédents",
        "Comme d'hab ahaha "
    ]
 
    /*
     Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ")
     */
}
