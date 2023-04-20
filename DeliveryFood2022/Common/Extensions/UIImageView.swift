import UIKit
import Kingfisher

extension UIImageView {
    func loadImageFromUrl(from urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .utility).async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                } catch {
                    print("Error = ", error.localizedDescription)

                }
            }
        }
    }
    
    func loadImage(from urlString: String, placeHolder: UIImage? = nil) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url, placeholder: placeHolder)
        }
    }
}
