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

// MARK: - Chart Pattern Drawings

struct HeadAndShouldersView: View {
    let signal: SignalType
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let flip = signal == .bullish
            Canvas { ctx, _ in
                var neck = Path()
                let neckY = flip ? h * 0.35 : h * 0.65
                neck.move(to: CGPoint(x: w*0.15, y: neckY))
                neck.addLine(to: CGPoint(x: w*0.85, y: neckY))
                ctx.stroke(neck, with: .color(.neckline), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))

                var path = Path()
                let pts: [(CGFloat,CGFloat)] = flip
                    ? [(0.1,0.6),(0.2,0.4),(0.3,0.55),(0.5,0.15),(0.7,0.55),(0.8,0.4),(0.9,0.6)]
                    : [(0.1,0.4),(0.2,0.6),(0.3,0.45),(0.5,0.85),(0.7,0.45),(0.8,0.6),(0.9,0.4)]
                path.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { path.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(path, with: .color(signal == .bullish ? .bullGreen : .bearRed),
                           style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
            }
        }
    }
}

struct DoubleTopView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.8),(0.2,0.2),(0.4,0.6),(0.6,0.22),(0.8,0.6),(0.95,0.9)]
                path.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { path.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(path, with: .color(.bearRed), style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                var neck = Path()
                neck.move(to: CGPoint(x: w*0.1, y: h*0.6)); neck.addLine(to: CGPoint(x: w*0.9, y: h*0.6))
                ctx.stroke(neck, with: .color(.neckline), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
            }
        }
    }
}

struct DoubleBottomView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.2),(0.2,0.8),(0.4,0.4),(0.6,0.78),(0.8,0.4),(0.95,0.1)]
                path.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { path.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(path, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                var neck = Path()
                neck.move(to: CGPoint(x: w*0.1, y: h*0.4)); neck.addLine(to: CGPoint(x: w*0.9, y: h*0.4))
                ctx.stroke(neck, with: .color(.neckline), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
            }
        }
    }
}

struct TripleTopView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.75),(0.2,0.2),(0.32,0.6),(0.5,0.22),(0.68,0.6),(0.8,0.22),(0.95,0.85)]
                path.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { path.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(path, with: .color(.bearRed), style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                var neck = Path()
                neck.move(to: CGPoint(x: w*0.05, y: h*0.6)); neck.addLine(to: CGPoint(x: w*0.95, y: h*0.6))
                ctx.stroke(neck, with: .color(.neckline), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
            }
        }
    }
}

struct TripleBottomView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.25),(0.2,0.8),(0.32,0.4),(0.5,0.78),(0.68,0.4),(0.8,0.78),(0.95,0.15)]
                path.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { path.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(path, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
                var neck = Path()
                neck.move(to: CGPoint(x: w*0.05, y: h*0.4)); neck.addLine(to: CGPoint(x: w*0.95, y: h*0.4))
                ctx.stroke(neck, with: .color(.neckline), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
            }
        }
    }
}

struct RoundedTopView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                path.move(to: CGPoint(x: w*0.05, y: h*0.75))
                path.addCurve(to: CGPoint(x: w*0.95, y: h*0.75),
                              control1: CGPoint(x: w*0.2, y: h*0.05),
                              control2: CGPoint(x: w*0.8, y: h*0.05))
                ctx.stroke(path, with: .color(.bearRed), style: StrokeStyle(lineWidth: 2.5))
            }
        }
    }
}

struct RoundedBottomView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var path = Path()
                path.move(to: CGPoint(x: w*0.05, y: h*0.25))
                path.addCurve(to: CGPoint(x: w*0.95, y: h*0.25),
                              control1: CGPoint(x: w*0.2, y: h*0.95),
                              control2: CGPoint(x: w*0.8, y: h*0.95))
                ctx.stroke(path, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2.5))
            }
        }
    }
}

struct CupAndHandleView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var cup = Path()
                cup.move(to: CGPoint(x: w*0.05, y: h*0.2))
                cup.addCurve(to: CGPoint(x: w*0.68, y: h*0.2),
                             control1: CGPoint(x: w*0.2, y: h*0.9),
                             control2: CGPoint(x: w*0.53, y: h*0.9))
                ctx.stroke(cup, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2.5))
                var handle = Path()
                handle.move(to: CGPoint(x: w*0.68, y: h*0.2))
                handle.addLine(to: CGPoint(x: w*0.75, y: h*0.38))
                handle.addLine(to: CGPoint(x: w*0.82, y: h*0.25))
                handle.addLine(to: CGPoint(x: w*0.95, y: h*0.15))
                ctx.stroke(handle, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2.5, lineJoin: .round))
            }
        }
    }
}

struct AscendingTriangleView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var top = Path()
                top.move(to: CGPoint(x: w*0.05, y: h*0.25)); top.addLine(to: CGPoint(x: w*0.95, y: h*0.25))
                ctx.stroke(top, with: .color(.bearRed.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var bot = Path()
                bot.move(to: CGPoint(x: w*0.05, y: h*0.85)); bot.addLine(to: CGPoint(x: w*0.85, y: h*0.28))
                ctx.stroke(bot, with: .color(.bullGreen.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.85),(0.2,0.25),(0.3,0.65),(0.45,0.25),(0.55,0.5),(0.7,0.25),(0.85,0.28),(0.95,0.15)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct DescendingTriangleView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var bot = Path()
                bot.move(to: CGPoint(x: w*0.05, y: h*0.75)); bot.addLine(to: CGPoint(x: w*0.95, y: h*0.75))
                ctx.stroke(bot, with: .color(.bullGreen.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var top = Path()
                top.move(to: CGPoint(x: w*0.05, y: h*0.15)); top.addLine(to: CGPoint(x: w*0.85, y: h*0.72))
                ctx.stroke(top, with: .color(.bearRed.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.15),(0.2,0.75),(0.3,0.35),(0.45,0.75),(0.55,0.5),(0.7,0.75),(0.85,0.72),(0.95,0.85)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.bearRed), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct SymmetricalTriangleView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var top = Path()
                top.move(to: CGPoint(x: w*0.05, y: h*0.15)); top.addLine(to: CGPoint(x: w*0.85, y: h*0.5))
                ctx.stroke(top, with: .color(.bearRed.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var bot = Path()
                bot.move(to: CGPoint(x: w*0.05, y: h*0.85)); bot.addLine(to: CGPoint(x: w*0.85, y: h*0.5))
                ctx.stroke(bot, with: .color(.bullGreen.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.15),(0.2,0.85),(0.35,0.25),(0.5,0.75),(0.65,0.38),(0.8,0.6),(0.85,0.5),(0.95,0.3)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.primary.opacity(0.7)), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct RisingChannelView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var top = Path(); top.move(to: CGPoint(x: w*0.05, y: h*0.55)); top.addLine(to: CGPoint(x: w*0.95, y: h*0.05))
                var bot = Path(); bot.move(to: CGPoint(x: w*0.05, y: h*0.85)); bot.addLine(to: CGPoint(x: w*0.95, y: h*0.35))
                ctx.stroke(top, with: .color(.bullGreen.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                ctx.stroke(bot, with: .color(.bullGreen.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.85),(0.2,0.55),(0.35,0.65),(0.5,0.35),(0.65,0.5),(0.8,0.2),(0.95,0.35)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.bullGreen), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct FallingChannelView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var top = Path(); top.move(to: CGPoint(x: w*0.05, y: h*0.15)); top.addLine(to: CGPoint(x: w*0.95, y: h*0.65))
                var bot = Path(); bot.move(to: CGPoint(x: w*0.05, y: h*0.45)); bot.addLine(to: CGPoint(x: w*0.95, y: h*0.95))
                ctx.stroke(top, with: .color(.bearRed.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                ctx.stroke(bot, with: .color(.bearRed.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.05,0.15),(0.2,0.45),(0.35,0.3),(0.5,0.65),(0.65,0.45),(0.8,0.78),(0.95,0.65)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.bearRed), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct FlagView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let color: Color = isBull ? .bullGreen : .bearRed
            Canvas { ctx, _ in
                var pole = Path()
                if isBull { pole.move(to: CGPoint(x: w*0.15, y: h*0.85)); pole.addLine(to: CGPoint(x: w*0.4, y: h*0.15)) }
                else       { pole.move(to: CGPoint(x: w*0.15, y: h*0.15)); pole.addLine(to: CGPoint(x: w*0.4, y: h*0.85)) }
                ctx.stroke(pole, with: .color(color), style: StrokeStyle(lineWidth: 3))
                let flagPts: [(CGFloat,CGFloat)] = isBull
                    ? [(0.4,0.15),(0.55,0.28),(0.65,0.2),(0.75,0.33),(0.85,0.25),(0.95,0.1)]
                    : [(0.4,0.85),(0.55,0.72),(0.65,0.8),(0.75,0.67),(0.85,0.75),(0.95,0.9)]
                var flag = Path()
                flag.move(to: CGPoint(x: w*flagPts[0].0, y: h*flagPts[0].1))
                for pt in flagPts.dropFirst() { flag.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(flag, with: .color(color), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
    }
}

struct PennantView: View {
    let isBull: Bool
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            let color: Color = isBull ? .bullGreen : .bearRed
            Canvas { ctx, _ in
                var pole = Path()
                if isBull { pole.move(to: CGPoint(x: w*0.15, y: h*0.85)); pole.addLine(to: CGPoint(x: w*0.35, y: h*0.15)) }
                else       { pole.move(to: CGPoint(x: w*0.15, y: h*0.15)); pole.addLine(to: CGPoint(x: w*0.35, y: h*0.85)) }
                ctx.stroke(pole, with: .color(color), style: StrokeStyle(lineWidth: 3))
                let y1: CGFloat = isBull ? 0.15 : 0.85
                let y2: CGFloat = isBull ? 0.25 : 0.75
                var t1 = Path(); t1.move(to: CGPoint(x: w*0.35, y: h*y1)); t1.addLine(to: CGPoint(x: w*0.75, y: h*0.5))
                var t2 = Path(); t2.move(to: CGPoint(x: w*0.35, y: h*y2)); t2.addLine(to: CGPoint(x: w*0.75, y: h*0.5))
                ctx.stroke(t1, with: .color(color.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [4,3]))
                ctx.stroke(t2, with: .color(color.opacity(0.7)), style: StrokeStyle(lineWidth: 1.5, dash: [4,3]))
                var breakout = Path()
                breakout.move(to: CGPoint(x: w*0.75, y: h*0.5))
                breakout.addLine(to: CGPoint(x: w*0.95, y: isBull ? h*0.2 : h*0.8))
                ctx.stroke(breakout, with: .color(color), style: StrokeStyle(lineWidth: 2.5))
            }
        }
    }
}

struct RectanglePatternView: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
            Canvas { ctx, _ in
                var top = Path(); top.move(to: CGPoint(x: w*0.1, y: h*0.25)); top.addLine(to: CGPoint(x: w*0.85, y: h*0.25))
                var bot = Path(); bot.move(to: CGPoint(x: w*0.1, y: h*0.75)); bot.addLine(to: CGPoint(x: w*0.85, y: h*0.75))
                ctx.stroke(top, with: .color(.bearRed.opacity(0.8)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                ctx.stroke(bot, with: .color(.bullGreen.opacity(0.8)), style: StrokeStyle(lineWidth: 1.5, dash: [5,3]))
                var price = Path()
                let pts: [(CGFloat,CGFloat)] = [(0.1,0.75),(0.2,0.25),(0.35,0.75),(0.5,0.25),(0.65,0.75),(0.8,0.25),(0.9,0.1)]
                price.move(to: CGPoint(x: w*pts[0].0, y: h*pts[0].1))
                for pt in pts.dropFirst() { price.addLine(to: CGPoint(x: w*pt.0, y: h*pt.1)) }
                ctx.stroke(price, with: .color(.primary.opacity(0.7)), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
            }
        }
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
