import Foundation


class SignInScreenViewModel: ObservableObject {
    @Published var hasAlreadyAccount = false

    func toggleHasAlreadyAccount() {
        hasAlreadyAccount.toggle()
    }
    
    func sendCodeValiladation() {}
    
    func errorCodeValidation() {}
    
    func errorTimeOutCode() {}
}

