// MARK: - Presentation/Views/Home/HomeView.swift

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.pageBG.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : -20)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appeared)

                        VStack(spacing: 14) {
                            NavigationLink(destination: PatternListView(category: .chartPattern)) {
                                CategoryCard(category: .chartPattern, count: viewModel.totalChartPatterns)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 30)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: appeared)

                            NavigationLink(destination: PatternListView(category: .candlestick)) {
                                CategoryCard(category: .candlestick, count: viewModel.totalCandlestickPatterns)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 30)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.18), value: appeared)
                        }
                        .padding(.horizontal, 16)

                        quickStatsRow
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.26), value: appeared)

                        NavigationLink(destination: BookmarkListView()) {
                            BookmarkBannerView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.4).delay(0.32), value: appeared)

                        // BUG-3 FIX: .font(.appMicro) → AppFont.micro
                        Text("Offline · 18 mô hình giá · 20 mẫu nến")
                            .font(AppFont.micro)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 28)
                            .padding(.bottom, 40)
                            .opacity(appeared ? 1 : 0)
                            .animation(.easeOut(duration: 0.4).delay(0.38), value: appeared)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                withAnimation { appeared = true }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                // BUG-3 FIX: AppFont.micro thay vì .font(.appMicro)
                Text("POCKET GUIDE")
                    .font(AppFont.micro)
                    .foregroundStyle(.secondary)
                    .tracking(3)
                // BUG-3 FIX: AppFont.largeTitle thay vì .font(.appLargeTitle)
                Text("Cẩm Nang\nGiao Dịch")
                    .font(AppFont.largeTitle)
                    .foregroundStyle(.primary)
            }
            Spacer()
            appIcon
        }
        .padding(.horizontal, 20)
        .padding(.top, 64)
        .padding(.bottom, 24)
    }

    private var appIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 56, height: 56)
                .shadow(color: Color.appAccent.opacity(0.4), radius: 8, x: 0, y: 4)

            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    // MARK: - Quick Stats

    private var quickStatsRow: some View {
        HStack(spacing: 10) {
            StatPill(value: "\(viewModel.totalChartPatterns)", label: "Mô hình giá",
                     icon: "chart.xyaxis.line", color: .blue)
            StatPill(value: "\(viewModel.totalCandlestickPatterns)", label: "Mẫu nến",
                     icon: "chart.bar.fill", color: .green)
            StatPill(value: "100%", label: "Offline",
                     icon: "wifi.slash", color: .orange)
        }
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: PatternCategory
    let count: Int
    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(cardGradient)
                    .frame(width: 104)

                VStack(spacing: 6) {
                    Image(systemName: category.iconName)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)

                    if count > 0 {
                        Text("\(count)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("mô hình")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }
            .frame(height: 126)

            VStack(alignment: .leading, spacing: 7) {
                // BUG-3 FIX: AppFont.title / AppFont.caption
                Text(category.displayName)
                    .font(AppFont.title)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(category.subtitle)
                    .font(AppFont.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 4) {
                    Text("Khám phá")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.appAccent)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.appAccent)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)

            Spacer(minLength: 0)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.cardSurface)
                .shadow(
                    color: .black.opacity(isPressed ? 0.02 : 0.07),
                    radius: isPressed ? 4 : 14,
                    x: 0, y: isPressed ? 1 : 4
                )
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) {} onPressingChanged: { p in
            isPressed = p
        }
    }

    private var cardGradient: LinearGradient {
        switch category {
        case .chartPattern:
            return LinearGradient(
                colors: [Color(red: 0.25, green: 0.48, blue: 0.97), Color(red: 0.12, green: 0.30, blue: 0.85)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .candlestick:
            return LinearGradient(
                colors: [Color(red: 0.18, green: 0.72, blue: 0.44), Color(red: 0.08, green: 0.52, blue: 0.30)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - Stat Pill

struct StatPill: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Bookmark Banner

struct BookmarkBannerView: View {
    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 18))
                .foregroundStyle(.orange)
                .frame(width: 42, height: 42)
                .background(Color.orange.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text("Đã lưu")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                // BUG-3 FIX: AppFont.caption
                Text("Xem lại các mô hình đã bookmark")
                    .font(AppFont.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .cardStyle(cornerRadius: 14)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) {} onPressingChanged: { p in
            isPressed = p
        }
    }
}
