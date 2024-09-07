import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView!
    private let options = ["Сортировка файлов", "Изменить пароль"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        view.backgroundColor = .white
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        
        if indexPath.row == 0 {
            // Добавляем UISwitch для сортировки
            let sortSwitch = UISwitch(frame: .zero)
            sortSwitch.setOn(UserDefaults.standard.bool(forKey: "sortOrder"), animated: true)
            sortSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = sortSwitch
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            // Открываем экран для изменения пароля
            let changePasswordVC = ChangePasswordViewController()
            changePasswordVC.modalPresentationStyle = .formSheet
            present(changePasswordVC, animated: true, completion: nil)
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        // Сохраняем сортировку в UserDefaults
        UserDefaults.standard.set(sender.isOn, forKey: "sortOrder")
        UserDefaults.standard.synchronize() // Применяем изменения
    }
}
