import UIKit

class DocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var tableView: UITableView!  // Таблица для отображения списка изображений.
    private var images: [String] = []  // Массив для хранения имен изображений.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Documents"  // Устанавливаем заголовок экрана.
        view.backgroundColor = .white  // Устанавливаем белый цвет фона.
        
        setupTableView()  // Настраиваем таблицу.
        setupNavigationBar()  // Настраиваем кнопку в navigation bar.
        loadImagesFromDocumentsDirectory()  // Загружаем изображения из директории Documents.
    }
    
    // Настройка таблицы.
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)  // Инициализируем таблицу.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")  // Регистрируем ячейку.
        view.addSubview(tableView)  // Добавляем таблицу на экран.
    }
    
    // Настройка навигационной панели.
    private func setupNavigationBar() {
        // Используем системное изображение "plus" из SF Symbols для кнопки
        let addPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoTapped))
        navigationItem.rightBarButtonItem = addPhotoButton
    }

    // Обработчик нажатия на кнопку добавления фото.
    @objc private func addPhotoTapped() {
        let alertController = UIAlertController(title: "Enter file name", message: nil, preferredStyle: .alert)  // Показываем алерт для ввода имени файла.
        alertController.addTextField { textField in
            textField.placeholder = "File name"  // Добавляем текстовое поле.
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Проверяем, ввел ли пользователь имя файла. Если нет, используем UUID.
            if let fileName = alertController.textFields?.first?.text, !fileName.isEmpty {
                self.presentImagePicker(fileName: fileName)
            } else {
                self.presentImagePicker(fileName: UUID().uuidString)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    // Показ Image Picker для выбора изображения.
    private func presentImagePicker(fileName: String) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary  // Устанавливаем тип источника – фотобиблиотека.
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.accessibilityLabel = fileName  // Передаем имя файла через accessibilityLabel.
        present(picker, animated: true, completion: nil)
    }

    // Обработка выбора изображения.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        // Сохраняем изображение, если оно было выбрано.
        if let image = info[.originalImage] as? UIImage, let fileName = picker.accessibilityLabel {
            saveImage(image, withName: fileName)
            loadImagesFromDocumentsDirectory()  // Обновляем список файлов.
        }
    }

    // Сохранение изображения в Documents.
    private func saveImage(_ image: UIImage, withName name: String) {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(name + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.8) {
            fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)  // Сохраняем файл.
        }
    }

    // MARK: - UITableViewDataSource
    // Возвращаем количество строк в таблице.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    // Конфигурируем ячейки таблицы.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fileName = images[indexPath.row]
        
        // Загружаем изображение и информацию о файле.
        let imagePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        if let image = UIImage(contentsOfFile: imagePath) {
            cell.imageView?.image = image  // Устанавливаем изображение в ячейку.
        }
        
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: imagePath)
        if let fileSize = fileAttributes?[.size] as? Int, let creationDate = fileAttributes?[.creationDate] as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            cell.detailTextLabel?.text = "Size: \(fileSize) bytes, Created: \(formatter.string(from: creationDate))"  // Отображаем размер файла и дату создания.
        }
        
        cell.textLabel?.text = fileName  // Имя файла.
        return cell
    }
    
    // Обрабатываем выбор строки.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = images[indexPath.row]
        let imagePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        
        // Переход на экран с детальной информацией о выбранном изображении.
        if let image = UIImage(contentsOfFile: imagePath) {
            let detailVC = ImageDetailViewController()
            detailVC.image = image
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // MARK: - UITableViewDelegate
    // Разрешаем редактирование таблицы.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Обрабатываем удаление строки.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаляем изображение из документов и обновляем таблицу.
            deleteImage(named: images[indexPath.row])
            loadImagesFromDocumentsDirectory()  // Обновляем список файлов после удаления.
        }
    }
    
    // Удаление изображения из директории Documents.
    private func deleteImage(named imageName: String) {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(imageName)
        do {
            try fileManager.removeItem(at: fileURL)  // Пытаемся удалить файл.
        } catch {
            print("Failed to delete image: \(error.localizedDescription)")  // Обработка ошибки при удалении.
        }
    }
    
    // Возвращаем путь к директории Documents.
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Загрузка файлов из директории
    private func loadImagesFromDocumentsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        do {
            images = try fileManager.contentsOfDirectory(atPath: documentsURL.path)
            
            // Получаем настройку сортировки из UserDefaults
            let userDefaults = UserDefaults.standard
            let isSortAscending = userDefaults.bool(forKey: "sortOrder")
            
            // Сортируем массив изображений в зависимости от настройки
            images.sort(by: isSortAscending ? { $0 < $1 } : { $0 > $1 })
            
            tableView.reloadData()
        } catch {
            print("Failed to load images: \(error.localizedDescription)")
        }
    }

}
