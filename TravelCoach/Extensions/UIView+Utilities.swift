
import SwiftUI

struct CardStyle: ViewModifier {
    let background: Color
    func body(content: Content) -> some View {
        content
            .background(background)
            .foregroundColor(.white)
            .font(.custom("Satoshi-Bold", size: 17))
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle(_ background: Color? = .gray.opacity(0.6)) -> some View {
        self.modifier(CardStyle(background: background ?? .gray.opacity(0.6)))
    }
}

struct CardStyleBordered: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.gray.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

extension View {
    func cardStyleBordered() -> some View {
        self.modifier(CardStyleBordered())
    }
}
