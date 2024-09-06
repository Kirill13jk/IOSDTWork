import UIKit
import KeychainSwift  // Импорт библиотеки KeychainSwift

class PasswordViewController: UIViewController {
    // UI элементы
    private let passwordTextField = UITextField()
    private let actionButton = UIButton(type: .system)
    
    // Переменные для управления состояниями
    private var isFirstPasswordEntry = true  // Флаг для отслеживания, вводится ли пароль первый раз
    private var firstPassword: String?  // Хранение первого ввода пароля
    
    // KeychainSwift для хранения пароля
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        // Проверяем, сохранён ли пароль
        if keychain.get("password") != nil {
            // У пользователя уже есть пароль
            actionButton.setTitle("Введите пароль", for: .normal)
            isFirstPasswordEntry = false
        } else {
            // Пользователь ещё не создавал пароль
            actionButton.setTitle("Создать пароль", for: .normal)
        }
    }
    
    // Настройка UI
    private func setupUI() {
        passwordTextField.placeholder = "Введите пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(actionButton)
        
        // Устанавливаем ограничения для UI элементов
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20)
        ])
    }

    // Обработка нажатия на кнопку
    @objc private func actionButtonTapped() {
        guard let inputPassword = passwordTextField.text, inputPassword.count >= 4 else {
            showError(message: "Пароль должен содержать минимум 4 символа")
            return
        }
        
        // Проверяем, создаёт ли пользователь пароль впервые
        if isFirstPasswordEntry {
            if firstPassword == nil {
                // Первый ввод пароля
                firstPassword = inputPassword
                actionButton.setTitle("Повторите пароль", for: .normal)
                passwordTextField.text = ""
            } else {
                // Проверка повторного ввода пароля
                if firstPassword == inputPassword {
                    // Сохраняем пароль в Keychain
                    keychain.set(inputPassword, forKey: "password")
                    openNextScreen()  // Переход на следующий экран
                } else {
                    // Пароли не совпадают
                    showError(message: "Пароли не совпадают, попробуйте снова")
                    resetPasswordCreationState()  // Сброс состояния экрана
                }
            }
        } else {
            // Проверка сохранённого пароля
            if let storedPassword = keychain.get("password"), storedPassword == inputPassword {
                openNextScreen()  // Переход на следующий экран
            } else {
                showError(message: "Неверный пароль")
            }
        }
    }
    
    // Сброс состояния создания пароля
    private func resetPasswordCreationState() {
        firstPassword = nil
        actionButton.setTitle("Создать пароль", for: .normal)
        passwordTextField.text = ""
        isFirstPasswordEntry = true
    }
    
    // Переход на следующий экран (например, TabBarController)
    private func openNextScreen() {
        let tabBarController = UITabBarController()
        let documentsVC = DocumentsViewController()
        let settingsVC = SettingsViewController()
        
        // Настраиваем вкладки
        documentsVC.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder"), tag: 0)
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 1)
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: documentsVC), UINavigationController(rootViewController: settingsVC)]
        
        // Переход к TabBarController
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    // Показываем ошибку пользователю
    private func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
