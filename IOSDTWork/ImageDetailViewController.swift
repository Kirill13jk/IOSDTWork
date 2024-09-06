import UIKit

class ImageDetailViewController: UIViewController {
    var image: UIImage?  // Переменная для хранения изображения, переданного из предыдущего контроллера.

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // Устанавливаем белый цвет фона для представления.
        
        let imageView = UIImageView(image: image)  // Создаем UIImageView с изображением.
        imageView.contentMode = .scaleAspectFit  // Устанавливаем режим отображения: изображение сохраняет пропорции.
        imageView.frame = view.bounds  // Задаем рамки для imageView, равные размеру всего экрана.
        view.addSubview(imageView)  // Добавляем imageView в иерархию представлений.
    }
}
