
import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        Image("launch_image") // Replace "launchImage" with the name of your image asset
            .resizable()
            .scaledToFit()
            .background(Color.white) // Set a background color
    }
}
