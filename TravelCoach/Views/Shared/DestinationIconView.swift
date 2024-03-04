
import SwiftUI

struct DestinationIconView: View {
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

#Preview {
    DestinationIconView(iconData: Data())
}
