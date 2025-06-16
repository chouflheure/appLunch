
import SwiftUI

struct NavigationControllerAccessor: UIViewControllerRepresentable {
    var callback: (UINavigationController?) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            callback(controller.navigationController)
        }
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIViewController, context: Context
    ) {
        DispatchQueue.main.async {
            callback(uiViewController.navigationController)
        }
    }
}
