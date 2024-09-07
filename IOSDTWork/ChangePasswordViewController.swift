import UIKit
import KeychainSwift


// файл для смены пароля
class ChangePasswordViewController: UIViewController {
    
    let newPasswordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Изменить пароль"
        
        setupUI()
    }
    
    private func setupUI() {
        newPasswordTextField.placeholder = "Новый пароль"
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.borderStyle = .none
        newPasswordTextField.layer.cornerRadius = 8
        newPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.layer.borderColor = UIColor.systemGray4.cgColor
        newPasswordTextField.setLeftPaddingPoints(10)
        
        confirmPasswordTextField.placeholder = "Подтвердите пароль"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .none
        confirmPasswordTextField.layer.cornerRadius = 8
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = UIColor.systemGray4.cgColor
        confirmPasswordTextField.setLeftPaddingPoints(10)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(savePassword), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [newPasswordTextField, confirmPasswordTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func savePassword() {
        guard let newPassword = newPasswordTextField.text, let confirmPassword = confirmPasswordTextField.text, !newPassword.isEmpty, newPassword == confirmPassword else {
            showError("Пароли не совпадают")
            return
        }
        
        let keychain = KeychainSwift()
        keychain.set(newPassword, forKey: "userPassword")
        dismiss(animated: true, completion: nil)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// Extension для добавления отступов в UITextField
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
