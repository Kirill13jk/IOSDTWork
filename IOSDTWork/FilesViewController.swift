import UIKit

class FileListViewController: UIViewController {
    let filesLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        filesLabel.text = "Список файлов"
        filesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filesLabel)
        
        NSLayoutConstraint.activate([
            filesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
