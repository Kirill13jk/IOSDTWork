import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создаём контроллер для документов
        let documentsVC = UINavigationController(rootViewController: DocumentsViewController())
        documentsVC.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "folder"), tag: 0)

        // Создаём контроллер для настроек (можно кастомизировать)
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)

        // Добавляем контроллеры в TabBar
        viewControllers = [documentsVC, settingsVC]
    }
}
