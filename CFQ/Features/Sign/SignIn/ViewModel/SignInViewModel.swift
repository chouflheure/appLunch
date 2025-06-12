import Firebase
import FirebaseAuth
import Foundation
// import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published var uidUser = String()
    @Published var phoneNumber = String()
    var formattedNumber = String()
    @Published var verificationID = String()
    @Published var user: User? = nil
    @Published var isUserExist = false
    @Published var isSignFinish = false
    @Published var hasAlreadyAccount = false
    @Published var isConfirmScreenActive = false
    @Published var isEnabledResendCode: Bool = false
    @Published var numberTapResendCode: Int = 0
    
    var timer: Timer? = nil
    var timerContString: Timer? = nil
    private var timerCancellable: AnyCancellable?
    private var errorService = ErrorService()
    
    @Published var timerString: String = "10"
    private var secondsElapsed = 10
    
    private var cancellables = Set<AnyCancellable>()
    private let firebaseService = FirebaseService()

    func signInGuestMode() {
        isSignFinish = true
        isUserExist = true
        user = User().guestMode
    }

    private func closeConfirmScreen() {
        self.isConfirmScreenActive = false
        self.isSignFinish = true
        UserDefaults.standard.set(user?.uid, forKey: "userUID")
    }

    private func getUserWithIDConnexion(uid: String) {
        firebaseService.getDataByID(from: .users, with: uid) { (result: Result<User, Error>) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    self.isUserExist = true
                    self.closeConfirmScreen()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.user = nil
                    self.isUserExist = false
                    self.closeConfirmScreen()
                }
            }
        }
    }

    private func formatPhoneNumber(for phoneNumber: String) -> String {
        formattedNumber = phoneNumber

        if formattedNumber.hasPrefix("0") {
            formattedNumber = "+33" + formattedNumber.dropFirst()
        }

        return formattedNumber
    }

    func sendVerificationCode(completion: @escaping (Bool, String) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(
            formatPhoneNumber(for: phoneNumber), uiDelegate: nil
        ) { verificationID, error in
            if let error = error {
                completion(false, self.errorService.errorAuthFirebase(error: error))
                return
            }
            if let verificationID = verificationID {
                UserDefaults.standard.set(
                    verificationID,
                    forKey: "authVerificationID"
                )
                self.isConfirmScreenActive = true
                completion(true, "")
            }
        }
    }

    func verifyCode(
        for verificationCode: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(false, self.errorService.errorAuthFirebase(error: error))
                return
            }

            if let authResult = authResult {
                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                if isNewUser {
                    self.uidUser = authResult.user.uid
                    self.isUserExist = false
                    self.closeConfirmScreen()
                } else {
                    self.uidUser = authResult.user.uid
                    self.getUserWithIDConnexion(uid: authResult.user.uid)
                }
            }
        }
    }

    func startTimerString(delay: Double) {
        secondsElapsed = Int(delay)
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.secondsElapsed -= 1
                self.updateTimerString(delay: delay)
                if self.secondsElapsed <= 0 {
                    self.stopTimerString()
                }
            }
        }

    private func updateTimerString(delay: Double) {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        timerString  = delay == 600 ? String(format: "%02d:%02d", minutes, seconds) : String(format: "%02d", seconds)
    }

    private func stopTimerString() {
        timerCancellable?.cancel()
        timerString = ""
    }
    
    func dontReciveVerificationCode(
        completion: @escaping (Bool, String) -> Void
    ) {
        if numberTapResendCode >= 3 {
            startTimerLock(delay: 600)
            completion(false, "Vous avez tenté de réenvoyer le code 3 fois. Veuillez patienter 10 minutes avant de réessayer.")
            return
        } else {
            sendVerificationCode { (success, message) in
                if success {
                    self.numberTapResendCode += 1
                }
                completion(success, message)
            }
        }
    }

    func startTimerLock(delay: Double) {
        startTimerString(delay: delay)
        isEnabledResendCode = false
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.isEnabledResendCode = true
            if delay == 600 {
                self.numberTapResendCode = 0
            }
        }
    }

}
