// MARK: - Presentation/Views/Common/AppTheme.swift

import SwiftUI

// MARK: - App Colors

extension Color {
    // BUG-5 FIX: Đổi tên tránh trùng với SignalType.bullish / SignalType.bearish
    static let appAccent      = Color("AccentColor")
    static let appBullish     = Color(red: 0.18, green: 0.72, blue: 0.44)
    static let appBearish     = Color(red: 0.92, green: 0.26, blue: 0.33)
    static let appNeutral     = Color.orange
    static let cardSurface    = Color(.secondarySystemGroupedBackground)
    static let pageBG         = Color(.systemGroupedBackground)
}

// MARK: - Signal Color Helper

extension SignalType {
    // BUG-2 FIX: Dùng Color.appBullish thay vì .bullish để tránh ambiguity với enum case
    var color: Color {
        switch self {
        case .bullish: return Color.appBullish
        case .bearish: return Color.appBearish
        case .neutral: return Color.appNeutral
        }
    }

    var lightColor: Color { color.opacity(0.12) }
}

// MARK: - Typography — dùng enum namespace thay vì extension Font
// BUG-1 & BUG-3 FIX:
//   - extension Font không cho stored property → dùng enum AppFont
//   - .font(.appXxx) fail vì Font? context → gọi AppFont.xxx trực tiếp

enum AppFont {
    static var largeTitle: Font { .system(size: 32, weight: .bold) }
    static var title: Font      { .system(size: 20, weight: .bold) }
    static var headline: Font   { .system(size: 16, weight: .semibold) }
    static var body: Font       { .system(size: 15, weight: .regular) }
    static var caption: Font    { .system(size: 12, weight: .regular) }
    static var micro: Font      { .system(size: 10, weight: .medium, design: .monospaced) }
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 16
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.cardSurface)
                    .shadow(
                        color: .black.opacity(colorScheme == .dark ? 0 : 0.06),
                        radius: 10, x: 0, y: 3
                    )
            )
    }
}

// Shadow biến mất ở Dark mode (nền đã đủ tương phản), hiện rõ ở Light mode
struct AdaptiveShadowModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var opacity: Double
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content) -> some View {
        content.shadow(
            color: .black.opacity(colorScheme == .dark ? 0 : opacity),
            radius: radius, x: x, y: y
        )
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius))
    }

    func adaptiveShadow(opacity: Double, radius: CGFloat, x: CGFloat = 0, y: CGFloat) -> some View {
        modifier(AdaptiveShadowModifier(opacity: opacity, radius: radius, x: x, y: y))
    }
}

// MARK: - Press Button Style

struct CardPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: configuration.isPressed)
    }
}
