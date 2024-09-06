import UIKit
import KeychainSwift

class PasswordViewController: UIViewController {
    
    let passwordTextField = UITextField()
    let actionButton = UIButton(type: .system)
    let errorLabel = UILabel()

    let keychain = KeychainSwift()
    var isCreatingPassword = true
    var firstPasswordEntry: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        // Проверка, есть ли сохранённый пароль
        if keychain.get("userPassword") != nil {
            isCreatingPassword = false
            actionButton.setTitle("Введите пароль", for: .normal)
        } else {
            actionButton.setTitle("Создать пароль", for: .normal)
        }
    }
    
    // Настройка UI
    func setupUI() {
        passwordTextField.placeholder = "Введите пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        actionButton.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTextField)
        view.addSubview(actionButton)
        view.addSubview(errorLabel)
        
        // Установка ограничений для элементов UI
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func actionButtonPressed() {
        guard let enteredPassword = passwordTextField.text, enteredPassword.count >= 4 else {
            showError("Пароль должен содержать минимум 4 символа.")
            return
        }
        
        if isCreatingPassword {
            if firstPasswordEntry == nil {
                firstPasswordEntry = enteredPassword
                actionButton.setTitle("Повторите пароль", for: .normal)
                passwordTextField.text = ""
            } else {
                if firstPasswordEntry == enteredPassword {
                    // Сохранение пароля в Keychain
                    keychain.set(enteredPassword, forKey: "userPassword")
                    openNextScreen() // Переход на TabBar экран
                } else {
                    showError("Пароли не совпадают!")
                    resetToInitialState()
                }
            }
        } else {
            // Проверка сохранённого пароля
            if let savedPassword = keychain.get("userPassword"), savedPassword == enteredPassword {
                openNextScreen() // Переход на TabBar экран
            } else {
                showError("Неверный пароль!")
            }
        }
    }
    
    // Сброс экрана к начальному состоянию
    func resetToInitialState() {
        firstPasswordEntry = nil
        actionButton.setTitle("Создать пароль", for: .normal)
        passwordTextField.text = ""
    }
    
    // Показать ошибку
    func showError(_ message: String) {
        errorLabel.text = message
    }
    
    // Переход на следующий экран с TabBar
    func openNextScreen() {
        // Создаем MainTabBarController
        let tabBarVC = MainTabBarController()

        // Доступ к SceneDelegate для смены корневого контроллера
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

}




