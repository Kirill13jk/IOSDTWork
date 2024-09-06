import UIKit

class FileService {
    static let shared = FileService()  // Синглтон для удобного доступа к методам сервиса.
    
    // Возвращает URL для директории Documents.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Сохраняет изображение с указанным именем.
    func saveImage(_ image: UIImage, withName name: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(name)  // Формируем путь для файла.
        if let data = image.jpegData(compressionQuality: 0.8) {  // Преобразуем изображение в JPEG-формат.
            FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)  // Создаем файл.
        }
    }
    
    // Загружает список файлов из директории Documents.
    func loadImages() -> [String] {
        let documentsURL = getDocumentsDirectory()
        let contents = try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path)  // Читаем содержимое директории.
        return contents ?? []  // Возвращаем список файлов, если он есть.
    }
    
    // Удаляет изображение по имени файла.
    func deleteImage(named name: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(name)  // Получаем URL для файла.
        try? FileManager.default.removeItem(at: fileURL)  // Пытаемся удалить файл.
    }
}
