import Popovers
import SwiftUI

struct PopView: View {
    @State var present = false
    @State var expanding = false

    var body: some View {
        Button {
            present = true
        } label: {
            Text("Click")
        }
        .popover(
            present: $present,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    withAnimation(.easeIn(duration: 0.15)) {
                        expanding = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            expanding = false
                        }
                    }
                }
            }
        ) {
            AlertViewPopover(present: $present, expanding: $expanding)
        } background: {
            Color.black.opacity(0.1)
        }
    }
}

struct AlertViewPopover: View {
    @Binding var present: Bool
    @Binding var expanding: Bool

    /// the initial animation
    @State var scaled = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {

                Button(action: {
                        // Action for Menu Item 1
                    }) {
                        Label("Move this activity to another day.", systemImage: "move.3d")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    Button(action: {
                        // Action for Menu Item 2
                    }) {
                        Label("Remove this activity", systemImage: "pip.remove")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button(action: {
                        // Action for Menu Item 2
                    }) {
                        Label("Add more activities like this one.", systemImage: "rectangle.and.pencil.and.ellipsis")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                
                }
            .padding()

            Divider()

            Button {
                present = false
            } label: {
                Text("Cancel")
                    .foregroundColor(.blue)
            }
            .buttonStyle(Templates.AlertButtonStyle())
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .frame(width: 260)
        .scaleEffect(expanding ? 1.05 : 1)
        .scaleEffect(scaled ? 2 : 1)
        .opacity(scaled ? 0 : 1)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {
                scaled = false
            }
        }
    }
}
