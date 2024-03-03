
import SwiftUI

struct AccountView: View {
    @Binding var presentSideMenu: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("Account here...")

            }
            .navigationTitle("Account Settings".uppercased())
            .navigationBarItems(leading:
                Button{
                    presentSideMenu.toggle()
                } label: {
                    Image("menu")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            )
        }
    }
}
