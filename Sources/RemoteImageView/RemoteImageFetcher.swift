
import Foundation

import SwiftUI

public class RemoteImageFetcher: ObservableObject {
    @Published var imageData = Data()
    let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    // 1 Метод fetch, который используется URLSessionдля извлечения данных и установки результата в виде объектов imageData.
    public func fetch() {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }
    
    // 2 Метод получения данных изображения.
    public func getImageData() -> Data {
        return imageData
    }
    
    // 3 Метод получения URL.
    public func getUrl() -> URL {
        return url
    }
    
    public func purge() {
        imageData = Data()
    }
    
}
