
import SwiftUI

struct NavigationBarSubViews: View {
    let onAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                self.onAction()
            }) {
                HStack {
                    Image(systemName: "list.bullet.circle.fill")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.wbPinkMedium)
                    Text("MY TRIPS")
                        .font(.custom("Bevellier-Regular", size: 22))
                        .foregroundColor(Color.wbPinkMediumAlt)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(15)
            }
            Spacer()
        }
    }
}
