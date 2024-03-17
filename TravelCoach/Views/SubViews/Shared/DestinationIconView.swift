
import SwiftUI

struct DestinationIconDataView: View {
    let iconData: Data?
    var size: CGFloat?
    
    func setImage() -> Image {
        if let iconData = iconData, let uiImage = UIImage(data: iconData) {
            return Image(uiImage: uiImage)
        } else {
            return Image("destination_placeholder")
        }
    }
    
    var body: some View {
        if let size = self.size {
            self.setImage()
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .edgesIgnoringSafeArea(.all)
                .clipShape(RoundedRectangle(cornerRadius: 7))
        } else {
            self.setImage()
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct DestinationIconView: View {
    let image: Image
    var size: CGFloat?
    
    var body: some View {
        self.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .edgesIgnoringSafeArea(.all)
            .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}

struct DestinationBackgroundIconView: View {
    let iconData: Data?
    
    func setImage() -> Image {
        if let iconData = iconData, let uiImage = UIImage(data: iconData) {
            return Image(uiImage: uiImage)
        } else {
            return Image("destination_placeholder")
        }
    }
    
    var body: some View {
        self.setImage()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .ignoresSafeArea(.all)
    }
}
