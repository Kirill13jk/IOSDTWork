import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Создаём контроллеры для табов
        let fileListVC = UINavigationController(rootViewController: FileListViewController())
        fileListVC.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder"), tag: 0)
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 1)

        // Добавляем контроллеры в таббар
        viewControllers = [fileListVC, settingsVC]
    }
}
