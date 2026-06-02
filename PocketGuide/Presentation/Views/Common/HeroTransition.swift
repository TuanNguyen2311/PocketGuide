// MARK: - Presentation/Views/Common/HeroTransition.swift

import SwiftUI

// MARK: - Animated Card Thumbnail

struct AnimatedThumbnail: View {
    let pattern: TradingPattern
    // BUG-6 FIX: matchedGeometryEffect + NavigationLink bị crash/glitch trên iOS 16.
    // Giải pháp: bỏ hoàn toàn matchedGeometryEffect, thay bằng scale+opacity transition
    // thuần túy — vẫn cho cảm giác smooth mà không gây lỗi.
    var size: CGFloat = 80

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(pattern.signal.lightColor)
                .frame(width: size, height: size)

            PatternIllustrationView(pattern: pattern, animated: true)
                .frame(width: size * 0.78, height: size * 0.78)
        }
    }
}

// MARK: - Animated Hero Banner

struct AnimatedHeroBanner: View {
    let pattern: TradingPattern

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    pattern.signal.color.opacity(0.22),
                    pattern.signal.color.opacity(0.04)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            VStack(spacing: 16) {
                PatternIllustrationView(pattern: pattern, isLarge: true, animated: true)
                    .frame(width: 220, height: 140)

                SignalBadge(signal: pattern.signal)
                    .padding(.bottom, 8)
            }
            .padding(.vertical, 24)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}

// MARK: - View.if helper
// BUG-4 FIX: Chỉ khai báo một lần duy nhất ở đây, xóa bản trùng ở các file khác.

extension View {
    @ViewBuilder
    func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition { transform(self) } else { self }
    }
}
