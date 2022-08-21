

import Foundation
import SwiftUI

public struct RemoteImageView<Content: View>: View {
  // 1 Представление удаленного изображения содержит свойства для хранения удаленного сборщика изображений, содержимого представления и изображения-заполнителя.
  @ObservedObject var imageFetcher: RemoteImageFetcher
  var content: (_ image: Image) -> Content
  let placeHolder: Image

  // 2 Состояние для хранения ссылки на предыдущий отображаемый URL-адрес и данные изображения.
  @State var previousURL: URL? = nil
  @State var imageData: Data = Data()

  // 3 Он инициализируется изображением-заполнителем, удаленным сборщиком изображений и замыканием, которое принимает файл Image.
  public init(
    placeHolder: Image,
    imageFetcher: RemoteImageFetcher,
    content: @escaping (_ image: Image) -> Content
  ) {
    self.placeHolder = placeHolder
    self.imageFetcher = imageFetcher
    self.content = content
  }

  // 4 Переменная SwiftUI body, которая получает свойства данных URL и изображения от сборщика и сохраняет их локально перед возвратом…
  public var body: some View {
    DispatchQueue.main.async {
      if (self.previousURL != self.imageFetcher.getUrl()) {
        self.previousURL = self.imageFetcher.getUrl()
      }

      if (!self.imageFetcher.imageData.isEmpty) {
        self.imageData = self.imageFetcher.imageData
      }
    }

    let uiImage = imageData.isEmpty ? nil : UIImage(data: imageData)
    let image = uiImage != nil ? Image(uiImage: uiImage!) : nil;

    // 5 ZStack, содержащий либо изображение, либо заполнитель . Этот стек вызывает приватный метод, loadImageкогда он появляется, что…
    return ZStack() {
      if image != nil {
        content(image!)
      } else {
        content(placeHolder)
      }
    }
    .onAppear(perform: loadImage)
  }

  // 6 Запрашивает сборщик изображений для получения данных изображения.
  private func loadImage() {
    imageFetcher.fetch()
  }
}

