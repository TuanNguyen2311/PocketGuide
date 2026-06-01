// MARK: - Presentation/Views/PatternDetail/PatternDetailView.swift

// BUG-9 FIX: Thêm import UIKit để dùng UIImpactFeedbackGenerator
import UIKit
import SwiftUI

struct PatternDetailView: View {
    let pattern: TradingPattern
    @StateObject private var viewModel: PatternDetailViewModel
    @State private var headerVisible = false

    // BUG-6 FIX: Bỏ hoàn toàn namespace parameter
    init(pattern: TradingPattern) {
        self.pattern = pattern
        _viewModel = StateObject(wrappedValue: PatternDetailViewModel(pattern: pattern))
    }

    var body: some View {
        ZStack {
            Color.pageBG.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // BUG-6 FIX: AnimatedHeroBanner không còn nhận namespace
                    AnimatedHeroBanner(pattern: pattern)

                    VStack(spacing: 14) {
                        descriptionCard
                        identificationCard
                        psychologyCard
                        tradingSetupCard
                        if !pattern.notes.isEmpty { notesCard }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(pattern.nameVi)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                bookmarkButton
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.15)) {
                headerVisible = true
            }
        }
    }

    // MARK: - Bookmark Button
    // BUG-7 & BUG-8 FIX: Xóa .symbolEffect và .contentTransition(.symbolEffect)
    // vì cả hai require iOS 17. Thay bằng .scaleEffect animation tương thích iOS 16.

    private var bookmarkButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                viewModel.toggleBookmark()
            }
            // BUG-9 FIX: UIKit đã được import ở trên
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } label: {
            Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(viewModel.isBookmarked ? .orange : .primary)
                // BUG-7 FIX: Thay .symbolEffect bằng scaleEffect thuần iOS 16
                .scaleEffect(viewModel.isBookmarked ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: viewModel.isBookmarked)
        }
    }

    // MARK: - Cards

    private var descriptionCard: some View {
        InfoCard(icon: "text.alignleft", title: "Mô tả", iconColor: .blue) {
            // BUG-3 FIX: AppFont.body thay vì .font(.appBody)
            Text(pattern.description)
                .font(AppFont.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(headerVisible ? 1 : 0)
        .offset(y: headerVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.35).delay(0.05), value: headerVisible)
    }

    private var identificationCard: some View {
        InfoCard(icon: "eye.fill", title: "Đặc điểm nhận dạng", iconColor: .indigo) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(pattern.identification.enumerated()), id: \.offset) { idx, item in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(idx + 1)")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Color.indigo, in: Circle())
                        Text(item)
                            .font(.system(size: 14))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .opacity(headerVisible ? 1 : 0)
        .offset(y: headerVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.35).delay(0.1), value: headerVisible)
    }

    private var psychologyCard: some View {
        InfoCard(icon: "brain", title: "Tâm lý thị trường", iconColor: .purple) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.purple.opacity(0.4))
                Text(pattern.psychology)
                    .font(.system(size: 14))
                    .italic()
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(12)
            .background(Color.purple.opacity(0.07), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .opacity(headerVisible ? 1 : 0)
        .offset(y: headerVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.35).delay(0.15), value: headerVisible)
    }

    private var tradingSetupCard: some View {
        TradingSetupCard(setup: pattern.tradingSetup)
            .opacity(headerVisible ? 1 : 0)
            .offset(y: headerVisible ? 0 : 20)
            .animation(.easeOut(duration: 0.35).delay(0.2), value: headerVisible)
    }

    private var notesCard: some View {
        InfoCard(icon: "lightbulb.fill", title: "Lưu ý thực chiến", iconColor: .orange) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(pattern.notes, id: \.self) { note in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "chevron.right.2")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.orange)
                            .padding(.top, 3)
                        Text(note)
                            .font(.system(size: 14))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .opacity(headerVisible ? 1 : 0)
        .offset(y: headerVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.35).delay(0.25), value: headerVisible)
    }
}

// MARK: - Info Card
// BUG-3 FIX: AppFont.headline

struct InfoCard<Content: View>: View {
    let icon: String
    let title: String
    let iconColor: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(iconColor)
                    .frame(width: 28, height: 28)
                    .background(iconColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                Text(title)
                    .font(AppFont.headline)
                    .foregroundStyle(.primary)
            }
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

// MARK: - Trading Setup Card

struct TradingSetupCard: View {
    let setup: TradingSetup

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "flag.2.crossed.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.green)
                    .frame(width: 28, height: 28)
                    .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))
                // BUG-3 FIX: AppFont.headline
                Text("Thiết lập giao dịch")
                    .font(AppFont.headline)
                    .foregroundStyle(.primary)
            }

            VStack(spacing: 8) {
                SetupRow(icon: "arrow.right.circle.fill", label: "VÀO LỆNH", text: setup.entry,    color: .green)
                SetupRow(icon: "scope",                   label: "MỤC TIÊU",  text: setup.target,   color: .blue)
                SetupRow(icon: "xmark.circle.fill",       label: "CẮT LỖ",    text: setup.stopLoss, color: .red)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

struct SetupRow: View {
    let icon: String
    let label: String
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {
                // BUG-3 FIX: AppFont.micro thay vì .font(.appMicro)
                Text(label)
                    .font(AppFont.micro)
                    .foregroundStyle(color)
                    .tracking(0.5)
                Text(text)
                    .font(.system(size: 13))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.07), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - Previews

#Preview("Chi tiết – Bearish") {
    NavigationStack {
        PatternDetailView(pattern: .previewBearish)
    }
}

#Preview("Chi tiết – Bullish") {
    NavigationStack {
        PatternDetailView(pattern: .previewBullish)
    }
}

#Preview("Chi tiết – Dark") {
    NavigationStack {
        PatternDetailView(pattern: .previewBearish)
    }
    .preferredColorScheme(.dark)
}
