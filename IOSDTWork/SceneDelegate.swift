import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаём окно и задаём корневой контроллер как PasswordViewController
        window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController(rootViewController: PasswordViewController())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
