import SwiftUI

extension Color {
    static func systemGray(_ id: Int) -> Color {
        switch id {
        case 0: return Color.primary
        case 1: return Color(UIColor.systemGray)
        case 2: return Color(UIColor.systemGray2)
        case 3: return Color(UIColor.systemGray3)
        case 4: return Color(UIColor.systemGray4)
        case 5: return Color(UIColor.systemGray5)
        case 6: return Color(UIColor.systemGray6)
        default: return Color(UIColor.systemBackground)
        }
    }
}

func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
    CGPoint(
        x: lhs.x + rhs.width,
        y: lhs.y + rhs.height
    )
}

func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
    CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
}
