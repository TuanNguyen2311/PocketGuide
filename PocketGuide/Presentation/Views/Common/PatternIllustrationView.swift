// MARK: - Presentation/Views/Common/PatternIllustrationView.swift

import SwiftUI

struct PatternIllustrationView: View {
    let pattern: TradingPattern
    var isLarge: Bool = false

    var body: some View {
        Group {
            switch pattern.id {
            case "cp001": HeadAndShouldersView(signal: .bearish)
            case "cp002": HeadAndShouldersView(signal: .bullish)
            case "cp003": DoubleTopView()
            case "cp004": DoubleBottomView()
            case "cp005": TripleTopView()
            case "cp006": TripleBottomView()
            case "cp007": RoundedTopView()
            case "cp008": RoundedBottomView()
            case "cp009": CupAndHandleView()
            case "cp010": AscendingTriangleView()
            case "cp011": DescendingTriangleView()
            case "cp012": SymmetricalTriangleView()
            case "cp013": RisingChannelView()
            case "cp014": FallingChannelView()
            case "cp015": FlagView(isBull: true)
            case "cp016": FlagView(isBull: false)
            case "cp017": PennantView(isBull: true)
            case "cp018": RectanglePatternView()
            case "cs001": CandleView(type: .hammer)
            case "cs002": CandleView(type: .hangingMan)
            case "cs003": CandleView(type: .invertedHammer)
            case "cs004": CandleView(type: .shootingStar)
            case "cs005": CandleView(type: .doji)
            case "cs006": EngulfingView(isBull: true)
            case "cs007": EngulfingView(isBull: false)
            case "cs008": StarPatternView(isMorning: true)
            case "cs009": StarPatternView(isMorning: false)
            case "cs010": ThreeSoldiersView(isBull: true)
            case "cs011": ThreeSoldiersView(isBull: false)
            case "cs012": PiercingLineView()
            case "cs013": DarkCloudCoverView()
            case "cs014": HaramiView(isBull: true)
            case "cs015": HaramiView(isBull: false)
            case "cs016": SpinningTopView()
            case "cs017": MarubozuView(isBull: true)
            case "cs018": MarubozuView(isBull: false)
            case "cs019": TweezerView(isTop: true)
            case "cs020": TweezerView(isTop: false)
            default: GenericPatternView(signal: pattern.signal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Color Helpers
// BUG-10 FIX: Dùng Color.appBullish / Color.appBearish từ AppTheme thay vì
// private bullGreen/bearRed để thống nhất toàn project.

private extension Color {
    static let bullGreen = Color(red: 0.18, green: 0.72, blue: 0.44)
    static let bearRed   = Color(red: 0.92, green: 0.26, blue: 0.33)
    static let neckline  = Color.orange.opacity(0.8)
}

// MARK: - Shared Candle Infrastructure

private struct CBar {
    let o: CGFloat, h: CGFloat, l: CGFloat, c: CGFloat  // 0=bottom, 1=top
    var bull: Bool { c >= o }
}

private func cb(_ o: CGFloat, _ h: CGFloat, _ l: CGFloat, _ c: CGFloat) -> CBar {
    CBar(o: o, h: h, l: l, c: c)
}

private struct CandleChartView: View {
    let bars: [CBar]
    var neckline: CGFloat? = nil   // 0=bottom, 1=top

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let n  = CGFloat(bars.count)
            let gap = max(1, w * 0.022)
            let bw  = (w - gap * (n - 1)) / n

            Canvas { ctx, _ in
                if let ny = neckline {
                    var line = Path()
                    let y = h * (1 - ny)
                    line.move(to: CGPoint(x: 0, y: y))
                    line.addLine(to: CGPoint(x: w, y: y))
                    ctx.stroke(line, with: .color(.neckline),
                               style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }
                for (i, bar) in bars.enumerated() {
                    let x  = CGFloat(i) * (bw + gap)
                    let cx = x + bw / 2
                    let color: Color = bar.bull ? .bullGreen : .bearRed
                    var wick = Path()
                    wick.move(to:    CGPoint(x: cx, y: h * (1 - bar.h)))
                    wick.addLine(to: CGPoint(x: cx, y: h * (1 - bar.l)))
                    ctx.stroke(wick, with: .color(color),
                               style: StrokeStyle(lineWidth: max(1, bw * 0.18)))
                    let top = h * (1 - max(bar.o, bar.c))
                    let bot = h * (1 - min(bar.o, bar.c))
                    ctx.fill(
                        Path(CGRect(x: x, y: top, width: bw, height: max(bot - top, 1.5))),
                        with: .color(color)
                    )
                }
            }
        }
    }
}

// MARK: - Chart Pattern Drawings (Candlestick-based)

struct HeadAndShouldersView: View {
    let signal: SignalType
    var body: some View {
        let (bars, neck): ([CBar], CGFloat) = signal == .bearish ? ([
            cb(0.25,0.44,0.23,0.42), cb(0.42,0.60,0.40,0.58),
            cb(0.58,0.70,0.56,0.66), cb(0.66,0.68,0.40,0.42),
            cb(0.42,0.62,0.40,0.60), cb(0.60,0.90,0.58,0.86),
            cb(0.86,0.88,0.38,0.42), cb(0.42,0.66,0.40,0.63),
            cb(0.63,0.65,0.38,0.41), cb(0.41,0.42,0.18,0.22),
        ], 0.41) : ([
            cb(0.75,0.77,0.58,0.60), cb(0.60,0.62,0.42,0.44),
            cb(0.44,0.46,0.32,0.34), cb(0.34,0.62,0.32,0.60),
            cb(0.60,0.62,0.42,0.44), cb(0.44,0.46,0.12,0.14),
            cb(0.14,0.62,0.12,0.60), cb(0.60,0.62,0.36,0.38),
            cb(0.38,0.62,0.36,0.60), cb(0.60,0.82,0.58,0.80),
        ], 0.60)
        CandleChartView(bars: bars, neckline: neck)
    }
}

struct DoubleTopView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.28,0.42,0.26,0.40), cb(0.40,0.62,0.38,0.60),
            cb(0.60,0.82,0.58,0.78), cb(0.78,0.80,0.55,0.58),
            cb(0.58,0.60,0.40,0.42), cb(0.42,0.60,0.40,0.58),
            cb(0.58,0.82,0.56,0.76), cb(0.76,0.78,0.36,0.30),
            cb(0.30,0.32,0.18,0.20),
        ], neckline: 0.42)
    }
}

struct DoubleBottomView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.72,0.74,0.57,0.58), cb(0.58,0.60,0.42,0.44),
            cb(0.44,0.46,0.22,0.24), cb(0.24,0.26,0.20,0.22),
            cb(0.22,0.62,0.20,0.60), cb(0.60,0.62,0.43,0.45),
            cb(0.45,0.47,0.20,0.22), cb(0.22,0.64,0.20,0.62),
            cb(0.62,0.78,0.60,0.76),
        ], neckline: 0.60)
    }
}

struct TripleTopView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.28,0.44,0.26,0.42), cb(0.42,0.80,0.40,0.76),
            cb(0.76,0.78,0.41,0.43), cb(0.43,0.80,0.41,0.76),
            cb(0.76,0.78,0.40,0.42), cb(0.42,0.80,0.40,0.75),
            cb(0.75,0.77,0.36,0.30), cb(0.30,0.32,0.15,0.18),
        ], neckline: 0.42)
    }
}

struct TripleBottomView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.72,0.74,0.57,0.58), cb(0.58,0.60,0.20,0.22),
            cb(0.22,0.62,0.20,0.60), cb(0.60,0.62,0.20,0.22),
            cb(0.22,0.62,0.20,0.60), cb(0.60,0.62,0.20,0.22),
            cb(0.22,0.64,0.20,0.62), cb(0.62,0.80,0.60,0.78),
        ], neckline: 0.60)
    }
}

struct RoundedTopView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.32,0.46,0.30,0.44), cb(0.44,0.58,0.42,0.57),
            cb(0.57,0.68,0.55,0.67), cb(0.67,0.74,0.65,0.73),
            cb(0.73,0.77,0.71,0.75), cb(0.75,0.77,0.68,0.70),
            cb(0.70,0.72,0.60,0.62), cb(0.62,0.64,0.50,0.52),
            cb(0.52,0.54,0.38,0.40), cb(0.40,0.42,0.26,0.28),
        ])
    }
}

struct RoundedBottomView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.70,0.72,0.56,0.58), cb(0.58,0.60,0.46,0.48),
            cb(0.48,0.50,0.36,0.38), cb(0.38,0.40,0.28,0.30),
            cb(0.30,0.32,0.24,0.26), cb(0.26,0.30,0.24,0.28),
            cb(0.28,0.42,0.26,0.40), cb(0.40,0.54,0.38,0.52),
            cb(0.52,0.66,0.50,0.64), cb(0.64,0.78,0.62,0.76),
        ])
    }
}

struct CupAndHandleView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.72,0.74,0.57,0.58), cb(0.58,0.60,0.44,0.46),
            cb(0.46,0.48,0.30,0.32), cb(0.32,0.40,0.28,0.38),
            cb(0.38,0.54,0.36,0.52), cb(0.52,0.68,0.50,0.70),
            cb(0.70,0.72,0.60,0.62), cb(0.62,0.64,0.56,0.58),
            cb(0.58,0.60,0.54,0.56), cb(0.56,0.86,0.54,0.84),
        ])
    }
}

struct AscendingTriangleView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.24,0.40,0.22,0.38), cb(0.38,0.72,0.36,0.70),
            cb(0.70,0.72,0.40,0.42), cb(0.42,0.72,0.40,0.70),
            cb(0.70,0.72,0.50,0.52), cb(0.52,0.72,0.50,0.70),
            cb(0.70,0.72,0.60,0.62), cb(0.62,0.88,0.60,0.86),
        ], neckline: 0.71)
    }
}

struct DescendingTriangleView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.72,0.84,0.70,0.82), cb(0.82,0.84,0.30,0.32),
            cb(0.32,0.68,0.30,0.66), cb(0.66,0.68,0.30,0.32),
            cb(0.32,0.54,0.30,0.52), cb(0.52,0.54,0.30,0.32),
            cb(0.32,0.42,0.30,0.40), cb(0.40,0.42,0.12,0.14),
        ], neckline: 0.31)
    }
}

struct SymmetricalTriangleView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.20,0.82,0.18,0.80), cb(0.80,0.82,0.24,0.26),
            cb(0.26,0.72,0.24,0.70), cb(0.70,0.72,0.30,0.32),
            cb(0.32,0.64,0.30,0.62), cb(0.62,0.64,0.38,0.40),
            cb(0.40,0.56,0.38,0.54), cb(0.54,0.56,0.44,0.46),
            cb(0.46,0.72,0.44,0.70),
        ])
    }
}

struct RisingChannelView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.18,0.34,0.16,0.32), cb(0.32,0.54,0.30,0.52),
            cb(0.52,0.56,0.40,0.42), cb(0.42,0.64,0.40,0.62),
            cb(0.62,0.66,0.52,0.54), cb(0.54,0.76,0.52,0.74),
            cb(0.74,0.78,0.64,0.66), cb(0.66,0.88,0.64,0.86),
        ])
    }
}

struct FallingChannelView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.84,0.88,0.68,0.70), cb(0.70,0.72,0.54,0.56),
            cb(0.56,0.64,0.52,0.62), cb(0.62,0.64,0.46,0.48),
            cb(0.48,0.56,0.44,0.54), cb(0.54,0.56,0.38,0.40),
            cb(0.40,0.48,0.36,0.46), cb(0.46,0.48,0.30,0.32),
        ])
    }
}

struct FlagView: View {
    let isBull: Bool
    var body: some View {
        CandleChartView(bars: isBull ? [
            cb(0.14,0.28,0.12,0.26), cb(0.26,0.44,0.24,0.42),
            cb(0.42,0.60,0.40,0.58),
            cb(0.58,0.60,0.48,0.50), cb(0.50,0.52,0.42,0.44), cb(0.44,0.46,0.38,0.40),
            cb(0.40,0.60,0.38,0.58), cb(0.58,0.80,0.56,0.78),
        ] : [
            cb(0.86,0.88,0.72,0.74), cb(0.74,0.76,0.58,0.60),
            cb(0.60,0.62,0.42,0.44),
            cb(0.44,0.52,0.42,0.50), cb(0.50,0.56,0.48,0.54), cb(0.54,0.58,0.52,0.56),
            cb(0.56,0.58,0.40,0.42), cb(0.42,0.44,0.22,0.24),
        ])
    }
}

struct PennantView: View {
    let isBull: Bool
    var body: some View {
        CandleChartView(bars: isBull ? [
            cb(0.14,0.28,0.12,0.26), cb(0.26,0.44,0.24,0.42),
            cb(0.42,0.60,0.40,0.58),
            cb(0.58,0.66,0.44,0.46), cb(0.46,0.62,0.44,0.60),
            cb(0.60,0.64,0.48,0.50), cb(0.50,0.60,0.48,0.58),
            cb(0.58,0.80,0.56,0.78),
        ] : [
            cb(0.86,0.88,0.72,0.74), cb(0.74,0.76,0.58,0.60),
            cb(0.60,0.62,0.42,0.44),
            cb(0.44,0.58,0.42,0.56), cb(0.56,0.58,0.44,0.46),
            cb(0.46,0.54,0.44,0.52), cb(0.52,0.54,0.46,0.48),
            cb(0.48,0.50,0.24,0.26),
        ])
    }
}

struct RectanglePatternView: View {
    var body: some View {
        CandleChartView(bars: [
            cb(0.38,0.72,0.36,0.68), cb(0.68,0.70,0.30,0.34),
            cb(0.34,0.72,0.32,0.68), cb(0.68,0.70,0.30,0.34),
            cb(0.34,0.72,0.32,0.68), cb(0.68,0.70,0.30,0.34),
            cb(0.34,0.88,0.32,0.86),
        ], neckline: 0.71)
    }
}

// MARK: - Candlestick Drawings

enum CandleType { case hammer, hangingMan, invertedHammer, shootingStar, doji }

struct CandleView: View {
    let type: CandleType
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let cx = w / 2, bw = w * 0.2
            Canvas { ctx, _ in
                let (bodyTop, bodyBot, wickTop, wickBot, color): (CGFloat,CGFloat,CGFloat,CGFloat,Color)
                switch type {
                case .hammer:         (bodyTop,bodyBot,wickTop,wickBot,color) = (h*0.3,h*0.45,h*0.3,h*0.85,.bullGreen)
                case .hangingMan:     (bodyTop,bodyBot,wickTop,wickBot,color) = (h*0.3,h*0.45,h*0.3,h*0.85,.bearRed)
                case .invertedHammer: (bodyTop,bodyBot,wickTop,wickBot,color) = (h*0.55,h*0.7,h*0.15,h*0.7,.bullGreen)
                case .shootingStar:   (bodyTop,bodyBot,wickTop,wickBot,color) = (h*0.55,h*0.7,h*0.15,h*0.7,.bearRed)
                case .doji:           (bodyTop,bodyBot,wickTop,wickBot,color) = (h*0.49,h*0.51,h*0.2,h*0.8,.primary)
                }
                var wick = Path(); wick.move(to: CGPoint(x: cx, y: wickTop)); wick.addLine(to: CGPoint(x: cx, y: wickBot))
                ctx.stroke(wick, with: .color(color), style: StrokeStyle(lineWidth: 2))
                ctx.fill(Path(CGRect(x: cx-bw/2, y: bodyTop, width: bw, height: bodyBot-bodyTop)), with: .color(color))
            }
        }
    }
}

struct EngulfingView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let c1x = w*0.38, c1W = w*0.14
                let bigColor: Color   = isBull ? .bearRed   : .bullGreen
                let smallColor: Color = isBull ? .bullGreen : .bearRed
                let c1Top: CGFloat = isBull ? h*0.3 : h*0.55
                let c1Bot: CGFloat = isBull ? h*0.55 : h*0.3
                var w1 = Path(); w1.move(to: CGPoint(x: c1x, y: isBull ? h*0.2 : h*0.65))
                w1.addLine(to: CGPoint(x: c1x, y: isBull ? h*0.65 : h*0.2))
                ctx.stroke(w1, with: .color(bigColor), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c1x-c1W/2, y: min(c1Top,c1Bot), width: c1W, height: abs(c1Bot-c1Top))), with: .color(bigColor))
                let c2x = w*0.63, c2W = w*0.18
                let c2Top: CGFloat = isBull ? h*0.2 : h*0.65
                let c2Bot: CGFloat = isBull ? h*0.65 : h*0.2
                var w2 = Path(); w2.move(to: CGPoint(x: c2x, y: isBull ? h*0.12 : h*0.72))
                w2.addLine(to: CGPoint(x: c2x, y: isBull ? h*0.72 : h*0.12))
                ctx.stroke(w2, with: .color(smallColor), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c2x-c2W/2, y: min(c2Top,c2Bot), width: c2W, height: abs(c2Bot-c2Top))), with: .color(smallColor))
            }
        }
    }
}

struct StarPatternView: View {
    let isMorning: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let morning: [(CGFloat, CGFloat, CGFloat, Color)] = [
                    (0.22, h*0.2,  h*0.65, .bearRed),
                    (0.5,  h*0.7,  h*0.8,  Color.primary),
                    (0.78, h*0.35, h*0.78, .bullGreen)
                ]
                let evening: [(CGFloat, CGFloat, CGFloat, Color)] = [
                    (0.22, h*0.35, h*0.78, .bullGreen),
                    (0.5,  h*0.2,  h*0.3,  Color.primary),
                    (0.78, h*0.2,  h*0.65, .bearRed)
                ]
                let candles = isMorning ? morning : evening
                for (cx,top,bot,color) in candles {
                    let bw = w*0.14
                    var wick = Path(); wick.move(to: CGPoint(x: w*cx, y: top-h*0.05)); wick.addLine(to: CGPoint(x: w*cx, y: bot+h*0.05))
                    ctx.stroke(wick, with: .color(color), style: StrokeStyle(lineWidth: 1.5))
                    ctx.fill(Path(CGRect(x: w*cx-bw/2, y: top, width: bw, height: bot-top)), with: .color(color))
                }
            }
        }
    }
}

struct ThreeSoldiersView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let color: Color = isBull ? .bullGreen : .bearRed
            Canvas { ctx, _ in
                let candles: [(CGFloat,CGFloat,CGFloat)] = isBull
                    ? [(0.25,h*0.45,h*0.75),(0.5,h*0.3,h*0.6),(0.75,h*0.15,h*0.45)]
                    : [(0.25,h*0.25,h*0.55),(0.5,h*0.4,h*0.7),(0.75,h*0.55,h*0.85)]
                for (cx,top,bot) in candles {
                    let bw = w*0.14
                    var wick = Path(); wick.move(to: CGPoint(x: w*cx, y: top-h*0.03)); wick.addLine(to: CGPoint(x: w*cx, y: bot+h*0.03))
                    ctx.stroke(wick, with: .color(color), style: StrokeStyle(lineWidth: 1.5))
                    ctx.fill(Path(CGRect(x: w*cx-bw/2, y: top, width: bw, height: bot-top)), with: .color(color))
                }
            }
        }
    }
}

struct PiercingLineView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let c1x = w*0.38, c1W = w*0.15
                var w1 = Path(); w1.move(to: CGPoint(x: c1x, y: h*0.15)); w1.addLine(to: CGPoint(x: c1x, y: h*0.75))
                ctx.stroke(w1, with: .color(.bearRed), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c1x-c1W/2, y: h*0.2, width: c1W, height: h*0.5)), with: .color(.bearRed))
                let c2x = w*0.63, c2W = w*0.15
                var w2 = Path(); w2.move(to: CGPoint(x: c2x, y: h*0.5)); w2.addLine(to: CGPoint(x: c2x, y: h*0.88))
                ctx.stroke(w2, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c2x-c2W/2, y: h*0.3, width: c2W, height: h*0.5)), with: .color(.bullGreen))
            }
        }
    }
}

struct DarkCloudCoverView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let c1x = w*0.38, c1W = w*0.15
                var w1 = Path(); w1.move(to: CGPoint(x: c1x, y: h*0.15)); w1.addLine(to: CGPoint(x: c1x, y: h*0.75))
                ctx.stroke(w1, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c1x-c1W/2, y: h*0.2, width: c1W, height: h*0.5)), with: .color(.bullGreen))
                let c2x = w*0.63, c2W = w*0.15
                var w2 = Path(); w2.move(to: CGPoint(x: c2x, y: h*0.1)); w2.addLine(to: CGPoint(x: c2x, y: h*0.82))
                ctx.stroke(w2, with: .color(.bearRed), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c2x-c2W/2, y: h*0.1, width: c2W, height: h*0.55)), with: .color(.bearRed))
            }
        }
    }
}

struct HaramiView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let bigColor: Color   = isBull ? .bearRed   : .bullGreen
                let smallColor: Color = isBull ? .bullGreen : .bearRed
                let c1x = w*0.38, c1W = w*0.17
                var w1 = Path(); w1.move(to: CGPoint(x: c1x, y: h*0.12)); w1.addLine(to: CGPoint(x: c1x, y: h*0.88))
                ctx.stroke(w1, with: .color(bigColor), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c1x-c1W/2, y: h*0.15, width: c1W, height: h*0.7)), with: .color(bigColor))
                let c2x = w*0.63, c2W = w*0.12
                var w2 = Path(); w2.move(to: CGPoint(x: c2x, y: h*0.37)); w2.addLine(to: CGPoint(x: c2x, y: h*0.63))
                ctx.stroke(w2, with: .color(smallColor), style: StrokeStyle(lineWidth: 1.5))
                ctx.fill(Path(CGRect(x: c2x-c2W/2, y: h*0.4, width: c2W, height: h*0.2)), with: .color(smallColor))
            }
        }
    }
}

struct SpinningTopView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let cx = w/2, bw = w*0.14
                var wick = Path(); wick.move(to: CGPoint(x: cx, y: h*0.15)); wick.addLine(to: CGPoint(x: cx, y: h*0.85))
                ctx.stroke(wick, with: .color(.primary), style: StrokeStyle(lineWidth: 2))
                ctx.fill(Path(CGRect(x: cx-bw/2, y: h*0.42, width: bw, height: h*0.16)), with: .color(.primary.opacity(0.6)))
            }
        }
    }
}

struct MarubozuView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let color: Color = isBull ? .bullGreen : .bearRed
            Canvas { ctx, _ in
                let cx = w/2, bw = w*0.2
                ctx.fill(Path(CGRect(x: cx-bw/2, y: h*0.15, width: bw, height: h*0.7)), with: .color(color))
            }
        }
    }
}

struct TweezerView: View {
    let isTop: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                let c1: (CGFloat,CGFloat,CGFloat,CGFloat,Color) = isTop
                    ? (0.35,h*0.25,h*0.55,h*0.2,.bullGreen)
                    : (0.35,h*0.45,h*0.75,h*0.82,.bearRed)
                let c2: (CGFloat,CGFloat,CGFloat,CGFloat,Color) = isTop
                    ? (0.65,h*0.25,h*0.65,h*0.78,.bearRed)
                    : (0.65,h*0.35,h*0.75,h*0.82,.bullGreen)
                for (cx,top,bot,wickEnd,color) in [c1,c2] {
                    let bw = w*0.14
                    var wick = Path()
                    wick.move(to: CGPoint(x: w*cx, y: min(top - h*0.05, wickEnd)))
                    wick.addLine(to: CGPoint(x: w*cx, y: max(bot, wickEnd)))
                    ctx.stroke(wick, with: .color(color), style: StrokeStyle(lineWidth: 1.5))
                    ctx.fill(Path(CGRect(x: w*cx-bw/2, y: top, width: bw, height: bot-top)), with: .color(color))
                }
                var line = Path()
                let lineY: CGFloat = isTop ? h*0.25 : h*0.75
                line.move(to: CGPoint(x: w*0.2, y: lineY)); line.addLine(to: CGPoint(x: w*0.8, y: lineY))
                ctx.stroke(line, with: .color(.orange.opacity(0.6)), style: StrokeStyle(lineWidth: 1.5, dash: [4,3]))
            }
        }
    }
}

struct GenericPatternView: View {
    let signal: SignalType
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                path.move(to: CGPoint(x: w*0.05, y: h*0.8))
                path.addCurve(to: CGPoint(x: w*0.95, y: h*0.2),
                              control1: CGPoint(x: w*0.35, y: h*0.85),
                              control2: CGPoint(x: w*0.65, y: h*0.15))
                let strokeColor = signal.color
                ctx.stroke(path, with: .color(strokeColor), style: StrokeStyle(lineWidth: 2.5))
            }
        }
    }
}
