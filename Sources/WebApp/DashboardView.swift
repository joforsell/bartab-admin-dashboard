import ElementaryUI

@View
struct DashboardView {
    @Binding var adminKey: String?

    var body: some View {
        div {
            header
            mainContent
        }
    }

    var header: some View {
        div {
            span { "Bartab" }
                .fontDisplay().fontSize(.rem(1.25)).color(.text)

            button { "Sign out" }
                .fontSize(.rem(0.8125))
                .color(.textMuted)
                .attributes(.style("background:none"))
                .border(.none)
                .cursor(.pointer)
                .padding(.rem(0.25), .rem(0.5))
                .onClick { _ in
                    AuthStorage.clear()
                    adminKey = nil
                }
        }
        .attributes(.style("border-bottom:1px solid var(--color-border)"))
        .padding(.rem(0.75), .rem(1)).display(.flex).alignItems(.center)
        .justifyContent(.spaceBetween).maxWidth(.px(1000)).margin(.px(0), .auto).width(.percent(100))
    }

    var mainContent: some View {
        div {
            img(.src("https://bartab.info/static/app-icon.svg"), .alt("Bartab"))
                .width(.px(80))
                .height(.px(80))
                .borderRadius(.px(18))
                .boxShadow(y: 4, blur: 16, color: .rgb(r: 0, g: 0, b: 0, alpha: 0.12))
                .margin(.px(0), .auto, .rem(1.5))
                .display(.block)

            h1 { "Admin Dashboard" }
                .fontDisplay()
                .fontWeight(.regular)
                .fontSize(.clamp(min: .rem(1.75), ideal: .vw(4), max: .rem(2.5)))
                .letterSpacing(.em(-0.02))
                .color(.text)

            div(.class("stats-grid")) {
                StatCard(label: "Active Venues", value: "142", trend: "+12 this month")
                StatCard(label: "Total Revenue", value: "$48,320", trend: "+8.4% vs last month")
                StatCard(label: "Transactions", value: "9,841", trend: "Last 30 days")
                StatCard(label: "Active Tabs", value: "37", trend: "Right now")
            }
        }
        .maxWidth(.px(1000))
        .margin(.px(0), .auto)
        .padding(.rem(3), .rem(1))
        .textAlign(.center)
    }
}

@View
struct StatCard {
    var label: String
    var value: String
    var trend: String

    var body: some View {
        div(.class("stat-card")) {
            p { label }
                .fontSize(.rem(0.75))
                .fontWeight(.semiBold)
                .textTransform(.uppercase)
                .letterSpacing(.em(0.05))
                .color(.textMuted)
                .margin(bottom: .rem(0.5))

            p { value }
                .fontDisplay()
                .fontSize(.rem(2))
                .fontWeight(.regular)
                .color(.text)
                .lineHeight(1.1)
                .margin(bottom: .rem(0.5))

            p { trend }
                .fontSize(.rem(0.8125))
                .color(.accent)
        }
        .backgroundColor(.bgSecondary)
        .borderRadius(.px(12))
        .padding(.rem(1.25), .rem(1))
        .textAlign(.left)
    }
}
