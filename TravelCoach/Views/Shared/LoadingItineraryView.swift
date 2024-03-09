
import SwiftUI

struct LoadingItineraryView: View {
    @State private var isAnimating = false
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    var icon: Data

    var body: some View {
        ZStack {
            DestinationIconDataView(iconData: self.icon)
                .animation(.easeInOut(duration: 0.3), value: true)
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.1), Color.white.opacity(0.3), Color.black.opacity(0.1)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .mask(
                                Rectangle()
                                    .rotationEffect(Angle(degrees: -30))
                            )
                            .offset(x: isAnimating ? -geometry.size.width : geometry.size.width)
                    }
                )
                .onChange(of: chatAPIViewModel.loadingMessage) { oldValue, newValue in
                    withAnimation(Animation.linear(duration: 0.75).repeatForever(autoreverses: false)) {
                        isAnimating = chatAPIViewModel.loadingMessage != nil
                    }
                }
                .onAppear {
                    // Start the animation
                    withAnimation(Animation.linear(duration: 0.75).repeatForever(autoreverses: false)) {
                        isAnimating = chatAPIViewModel.loadingMessage != nil
                    }
                }
        }
    }
}
