import Elementary
import ElementaryUI

// MARK: - ColorToken

/// Typed CSS color variable tokens matching the `--color-*` design tokens in ContentView.
public enum ColorToken: String {
    case bg
    case bgSecondary = "bg-secondary"
    case border
    case text
    case textMuted = "text-muted"
    case textSecondary = "text-secondary"
    case accent
    case error
}

// MARK: - Length

/// A CSS length or keyword value usable wherever a CSS `<length-percentage>` or `auto` is valid.
public enum Length {
    case auto
    case px(Int)
    case rem(Double)
    case em(Double)
    case percent(Int)
    case vh(Int)
    case vw(Int)
    case clamp(String)

    var css: String {
        switch self {
        case .auto:              return "auto"
        case let .px(n):         return "\(n)px"
        case let .rem(n):        return "\(n)rem"
        case let .em(n):         return "\(n)em"
        case let .percent(n):    return "\(n)%"
        case let .vh(n):         return "\(n)vh"
        case let .vw(n):         return "\(n)vw"
        case let .clamp(s):      return s
        }
    }

    static func clamp(min: Length, ideal: Length, max: Length) -> Length {
        .clamp("clamp(\(min.css),\(ideal.css),\(max.css))")
    }
}

// MARK: - Supporting enums

public enum Display: String {
    case flex, block, grid, none
    case inlineFlex = "inline-flex"
    case inlineBlock = "inline-block"
}

public enum AlignItems: String {
    case center, start, end, stretch, baseline
    case flexStart = "flex-start"
    case flexEnd = "flex-end"
}

public enum JustifyContent: String {
    case center, start, end, stretch
    case spaceBetween = "space-between"
    case spaceAround = "space-around"
    case flexStart = "flex-start"
    case flexEnd = "flex-end"
}

public enum TextAlign: String {
    case left, right, center, justify
}

public enum TextTransform: String {
    case uppercase, lowercase, capitalize, none
}

public enum Cursor: String {
    case pointer, auto, none
    case notAllowed = "not-allowed"
    case grab, grabbing
    case crosshair, wait
}

public enum BorderValue {
    case none
    case solid(width: Int = 1, color: ColorToken)

    var css: String {
        switch self {
        case .none: return "none"
        case let .solid(width, color): return "\(width)px solid var(--color-\(color.rawValue))"
        }
    }
}

public enum OutlineValue {
    case none
    case auto

    var css: String {
        switch self {
        case .none: return "none"
        case .auto: return "auto"
        }
    }
}

public enum ShadowColor {
    case rgb(r: Int, g: Int, b: Int, alpha: Double = 1)
    case token(ColorToken)

    var css: String {
        switch self {
        case let .rgb(r, g, b, alpha): return "rgba(\(r),\(g),\(b),\(alpha))"
        case let .token(token):        return "var(--color-\(token.rawValue))"
        }
    }
}

public enum FontWeight: CustomStringConvertible {
    case thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black
    case numeric(Int)

    public var description: String {
        switch self {
        case .thin:       return "100"
        case .extraLight: return "200"
        case .light:      return "300"
        case .regular:    return "400"
        case .medium:     return "500"
        case .semiBold:   return "600"
        case .bold:       return "700"
        case .extraBold:  return "800"
        case .black:      return "900"
        case .numeric(let n): return "\(n)"
        }
    }
}

// MARK: - View modifiers (chainable, SwiftUI-style)

public extension View where Tag: HTMLTrait.Attributes.Global {

    // MARK: Spacing

    /// Sets a single `padding-*` edge. e.g. `.padding(top: .rem(1))`, `.padding(bottom: .rem(0.5))`
    func padding(top value: Length) -> some View<Tag> { attributes(.style("padding-top:\(value.css)")) }
    func padding(bottom value: Length) -> some View<Tag> { attributes(.style("padding-bottom:\(value.css)")) }
    func padding(left value: Length) -> some View<Tag> { attributes(.style("padding-left:\(value.css)")) }
    func padding(right value: Length) -> some View<Tag> { attributes(.style("padding-right:\(value.css)")) }

    /// Sets `padding`. e.g. `.padding(.rem(1.5))` or `.padding(.rem(0.75), .rem(1))`
    func padding(_ a: Length) -> some View<Tag> { attributes(.style("padding:\(a.css)")) }
    func padding(_ a: Length, _ b: Length) -> some View<Tag> { attributes(.style("padding:\(a.css) \(b.css)")) }
    func padding(_ a: Length, _ b: Length, _ c: Length) -> some View<Tag> { attributes(.style("padding:\(a.css) \(b.css) \(c.css)")) }
    func padding(_ a: Length, _ b: Length, _ c: Length, _ d: Length) -> some View<Tag> { attributes(.style("padding:\(a.css) \(b.css) \(c.css) \(d.css)")) }

    /// Sets a single `margin-*` edge. e.g. `.margin(top: .rem(1))`, `.margin(bottom: .rem(0.5))`
    func margin(top value: Length) -> some View<Tag> { attributes(.style("margin-top:\(value.css)")) }
    func margin(bottom value: Length) -> some View<Tag> { attributes(.style("margin-bottom:\(value.css)")) }
    func margin(left value: Length) -> some View<Tag> { attributes(.style("margin-left:\(value.css)")) }
    func margin(right value: Length) -> some View<Tag> { attributes(.style("margin-right:\(value.css)")) }

    /// Sets `margin`. e.g. `.margin(.px(0), .auto)` or `.margin(.rem(1))`
    func margin(_ a: Length) -> some View<Tag> { attributes(.style("margin:\(a.css)")) }
    func margin(_ a: Length, _ b: Length) -> some View<Tag> { attributes(.style("margin:\(a.css) \(b.css)")) }
    func margin(_ a: Length, _ b: Length, _ c: Length) -> some View<Tag> { attributes(.style("margin:\(a.css) \(b.css) \(c.css)")) }
    func margin(_ a: Length, _ b: Length, _ c: Length, _ d: Length) -> some View<Tag> { attributes(.style("margin:\(a.css) \(b.css) \(c.css) \(d.css)")) }

    // MARK: Sizing

    /// Sets `width`. e.g. `.width(.percent(100))` or `.width(.px(380))`
    func width(_ value: Length) -> some View<Tag> {
        attributes(.style("width:\(value.css)"))
    }

    /// Sets `height`. e.g. `.height(.px(80))`
    func height(_ value: Length) -> some View<Tag> {
        attributes(.style("height:\(value.css)"))
    }

    /// Sets `min-width`. e.g. `.minWidth(.px(200))`
    func minWidth(_ value: Length) -> some View<Tag> {
        attributes(.style("min-width:\(value.css)"))
    }

    /// Sets `max-width`. e.g. `.maxWidth(.px(1000))`
    func maxWidth(_ value: Length) -> some View<Tag> {
        attributes(.style("max-width:\(value.css)"))
    }

    /// Sets `min-height`. e.g. `.minHeight(.vh(100))`
    func minHeight(_ value: Length) -> some View<Tag> {
        attributes(.style("min-height:\(value.css)"))
    }

    /// Sets `max-height`. e.g. `.maxHeight(.px(400))`
    func maxHeight(_ value: Length) -> some View<Tag> {
        attributes(.style("max-height:\(value.css)"))
    }

    /// Sets `border-radius`. e.g. `.borderRadius(.px(12))`
    func borderRadius(_ value: Length) -> some View<Tag> {
        attributes(.style("border-radius:\(value.css)"))
    }

    // MARK: Typography

    /// Sets `font-size`. e.g. `.fontSize(.rem(1))`
    func fontSize(_ value: Length) -> some View<Tag> {
        attributes(.style("font-size:\(value.css)"))
    }

    /// Sets `font-weight` using a named or numeric weight.
    func fontWeight(_ weight: FontWeight) -> some View<Tag> {
        attributes(.style("font-weight:\(weight)"))
    }

    /// Applies the display font family (`var(--font-display)`).
    func fontDisplay() -> some View<Tag> {
        attributes(.style("font-family:var(--font-display)"))
    }

    /// Sets `color` to a CSS variable token. e.g. `.color(.text)` → `color: var(--color-text)`
    func color(_ token: ColorToken) -> some View<Tag> {
        attributes(.style("color:var(--color-\(token.rawValue))"))
    }

    /// Sets `text-align`. e.g. `.textAlign(.center)`
    func textAlign(_ alignment: TextAlign) -> some View<Tag> {
        attributes(.style("text-align:\(alignment.rawValue)"))
    }

    /// Sets `letter-spacing`. e.g. `.letterSpacing(.em(-0.02))`
    func letterSpacing(_ value: Length) -> some View<Tag> {
        attributes(.style("letter-spacing:\(value.css)"))
    }

    /// Sets `line-height` to a unitless value.
    func lineHeight(_ value: Double) -> some View<Tag> {
        attributes(.style("line-height:\(value)"))
    }

    /// Sets `text-transform`. e.g. `.textTransform(.uppercase)`
    func textTransform(_ transform: TextTransform) -> some View<Tag> {
        attributes(.style("text-transform:\(transform.rawValue)"))
    }

    // MARK: Layout

    /// Sets `display`. e.g. `.display(.flex)`
    func display(_ value: Display) -> some View<Tag> {
        attributes(.style("display:\(value.rawValue)"))
    }

    /// Sets `align-items`. e.g. `.alignItems(.center)`
    func alignItems(_ value: AlignItems) -> some View<Tag> {
        attributes(.style("align-items:\(value.rawValue)"))
    }

    /// Sets `justify-content`. e.g. `.justifyContent(.spaceBetween)`
    func justifyContent(_ value: JustifyContent) -> some View<Tag> {
        attributes(.style("justify-content:\(value.rawValue)"))
    }

    // MARK: Background & Borders

    /// Sets `background-color` to a CSS variable token.
    func backgroundColor(_ token: ColorToken) -> some View<Tag> {
        attributes(.style("background-color:var(--color-\(token.rawValue))"))
    }

    /// Sets `border`. e.g. `.border(.none)` or `.border(.solid(color: .border))`
    func border(_ value: BorderValue) -> some View<Tag> {
        attributes(.style("border:\(value.css)"))
    }

    /// Sets `outline`. e.g. `.outline(.none)`
    func outline(_ value: OutlineValue) -> some View<Tag> {
        attributes(.style("outline:\(value.css)"))
    }

    /// Sets `cursor`. e.g. `.cursor(.pointer)`
    func cursor(_ value: Cursor) -> some View<Tag> {
        attributes(.style("cursor:\(value.rawValue)"))
    }

    /// Sets `box-shadow`. e.g. `.boxShadow(y: 4, blur: 16, color: .rgb(r: 0, g: 0, b: 0, alpha: 0.12))`
    func boxShadow(x: Int = 0, y: Int = 0, blur: Int = 0, spread: Int = 0, color: ShadowColor) -> some View<Tag> {
        attributes(.style("box-shadow:\(x)px \(y)px \(blur)px \(spread)px \(color.css)"))
    }
}
