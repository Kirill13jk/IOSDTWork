import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Создаём окно приложения
        window = UIWindow(windowScene: windowScene)
        
        // Устанавливаем PasswordViewController как начальный контроллер
        let passwordVC = PasswordViewController()
        let navigationController = UINavigationController(rootViewController: passwordVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
