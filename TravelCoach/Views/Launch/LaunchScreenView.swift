
import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("launch_image_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
