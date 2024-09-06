import UIKit

class SettingsViewController: UIViewController {
    
    // UI элементы
    private let sortSwitch = UISwitch()
    private let changePasswordButton = UIButton(type: .system)
    
    // UserDefaults для хранения настроек
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor = .white
        setupUI()
        
        // Загружаем сохранённое состояние сортировки
        let isSortAscending = userDefaults.bool(forKey: "sortOrder")
        sortSwitch.isOn = isSortAscending
    }
    
    // Настройка UI
    private func setupUI() {
        // Сортировка
        let sortLabel = UILabel()
        sortLabel.text = "Сортировка по алфавиту"
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortLabel)
        
        sortSwitch.translatesAutoresizingMaskIntoConstraints = false
        sortSwitch.addTarget(self, action: #selector(sortSwitchChanged), for: .valueChanged)
        view.addSubview(sortSwitch)
        
        // Кнопка для смены пароля
        changePasswordButton.setTitle("Поменять пароль", for: .normal)
        changePasswordButton.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        changePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(changePasswordButton)
        
        // Расположение элементов
        NSLayoutConstraint.activate([
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sortSwitch.centerYAnchor.constraint(equalTo: sortLabel.centerYAnchor),
            
            changePasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePasswordButton.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 40)
        ])
    }
    
    // Обработка изменения состояния сортировки
    @objc private func sortSwitchChanged() {
        userDefaults.set(sortSwitch.isOn, forKey: "sortOrder")
    }
    
    // Обработка смены пароля
    @objc private func changePasswordTapped() {
        // Переход на экран смены пароля
        let passwordVC = PasswordViewController()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
}
