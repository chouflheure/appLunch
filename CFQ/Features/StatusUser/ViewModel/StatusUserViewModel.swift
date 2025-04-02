import Combine
import Firebase

class SwitchStatusUserProfileViewModel: ObservableObject {
    private var firebase = FirebaseService()
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User

    init(user: User) {
        self.user = user

        user.$isActive
            .dropFirst()
            .sink { [weak self] newValue in
                self?.switchStatusClick(isActive: newValue)
            }
            .store(in: &cancellables)
    }

    private func switchStatusClick(isActive: Bool) {
        firebase.updateDataByID(data: ["isActive": isActive], to: .users, at: user.uid)
    }
}
