import UIKit

class SettingsViewController: UIViewController {
    let settingsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        settingsLabel.text = "Настройки"
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsLabel)
        
        NSLayoutConstraint.activate([
            settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
