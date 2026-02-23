import ElementaryUI

@View
struct DashboardView {
    @Binding var adminKey: String?

    @State private var activeUserCount: Int?
    @State private var subscriptionStats: SubscriptionStatsResponse?
    @State private var transactionStats: TransactionStatsResponse?
    @State private var isLoading = true

    var body: some View {
        div {
            header
            mainContent
        }
        .onAppear {
            Task {
                await fetchStats()
            }
        }
    }

    private func fetchStats() async {
        guard let token = adminKey else { return }

        let headers = ["Authorization": "Bearer \(token)"]

        let usersRequest = FetchRequest(method: .get, headers: headers)
        let subsRequest = FetchRequest(method: .get, headers: headers)
        let txRequest = FetchRequest(method: .get)

        async let usersResponse = usersRequest.send(to: "\(backendURL)/admin/stats/active-users")
        async let subsResponse = subsRequest.send(to: "\(backendURL)/admin/stats/subscriptions")
        async let txResponse = txRequest.send(to: "\(backendURL)/stats/transactions")

        if let response = try? await usersResponse, response.status == 200 {
            activeUserCount = (try? response.decode(ActiveUsersResponse.self))?.activeUserCount
        }

        if let response = try? await subsResponse, response.status == 200 {
            subscriptionStats = try? response.decode(SubscriptionStatsResponse.self)
        }

        if let response = try? await txResponse, response.status == 200 {
            transactionStats = try? response.decode(TransactionStatsResponse.self)
        }

        isLoading = false
    }

    var header: some View {
        div {
            span { "Bartab" }
                .styles(
                    .fontSize(.rem(1.25)), 
                    .color(.text)
                )

            button { "Sign out" }
                .styles(
                    .fontSize(.rem(0.8125)),
                    .color(.textMuted),
                    .custom(key: "background", value: "none"),
                    .border(.none),
                    .cursor(.pointer),
                    .padding(.rem(0.25), .rem(0.5))
                )
                .onClick { _ in
                    AuthStorage.clear()
                    adminKey = nil
                }
        }
        .styles(
            .custom(key: "border-bottom", value: "1px solid var(--color-border)"),
            .padding(.rem(0.75), .rem(1.0)),
            .display(.flex),
            .alignItems(.center),
            .justifyContent(.spaceBetween),
            .maxWidth(.px(1000)),
            .margin(.px(0), .auto),
            .width(.percent(100))
        )
    }

    var mainContent: some View {
        div {
            img(.src("https://bartab.info/static/app-icon.svg"), .alt("Bartab"))
                .styles(
                    .width(.clamp(min: .px(60), ideal: .vw(12), max: .px(80))),
                    .height(.clamp(min: .px(60), ideal: .vw(12), max: .px(80))),
                    .borderRadius(.px(18)),
                    .boxShadow(x: 0, y: 4, blur: 16, spread: 0, color: .rgb(r: 0, g: 0, b: 0, alpha: 0.12)),
                    .margin(.px(0), .auto, .clamp(min: .rem(1.0), ideal: .vw(3), max: .rem(1.5))),
                    .display(.block)
                )

            h1 { "Admin Dashboard" }
                .styles(
                    .fontDisplay,
                    .fontWeight(.regular),
                    .fontSize(.clamp(min: .rem(1.75), ideal: .vw(4), max: .rem(2.5))),
                    .letterSpacing(.em(-0.02)),
                    .color(.text)
                )

            div {
                h2 { "Past 30 Days" }
                    .styles(
                        .fontSize(.rem(1.125)),
                        .fontWeight(.semiBold),
                        .color(.text),
                        .textAlign(.left),
                        .margin(.top(.rem(2.0)))
                    )
                
                div(.class("stats-grid")) {
                    StatCard(
                        label: "Active Users",
                        value: activeUserCount.map(String.init) ?? "—",
                        trend: ""
                    )
                    StatCard(
                        label: "Transactions",
                        value: transactionStats.map { Formatters.formatNumber($0.transactionCount) } ?? "—",
                        trend: ""
                    )
                    StatCard(
                        label: "Total Processed",
                        value: transactionStats.map { Formatters.formatUSD($0.totalProcessedUSD) } ?? "—",
                        trend: "USD"
                    )
                }
            }
            
            div {
                h2 { "Current Subscriptions" }
                    .styles(
                        .fontSize(.rem(1.125)),
                        .fontWeight(.semiBold),
                        .color(.text),
                        .textAlign(.left),
                        .margin(.top(.rem(2.5)))
                    )
                
                div(.class("stats-grid")) {
                    StatCard(
                        label: "Monthly Subscribers",
                        value: subscriptionStats.map { String($0.monthly.total) } ?? "—",
                        trend: subscriptionStats.map { "\($0.monthly.optedOutOfRenewal) opted out" } ?? ""
                    )
                    StatCard(
                        label: "Annual Subscribers",
                        value: subscriptionStats.map { String($0.annual.total) } ?? "—",
                        trend: subscriptionStats.map { "\($0.annual.optedOutOfRenewal) opted out" } ?? ""
                    )
                    StatCard(
                        label: "Trials",
                        value: subscriptionStats.map { String($0.trial.total) } ?? "—",
                        trend: subscriptionStats.map { "\($0.trial.optedOutOfRenewal) opted out" } ?? ""
                    )
                }
            }
        }
        .styles(
            .maxWidth(.px(1000)),
            .margin(.px(0), .auto),
            .padding(.clamp(min: .rem(1.5), ideal: .vw(5), max: .rem(3.0)), .rem(1.0)),
            .textAlign(.center)
        )
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
                .styles(
                    .fontSize(.rem(0.75)),
                    .fontWeight(.semiBold),
                    .textTransform(.uppercase),
                    .letterSpacing(.em(0.05)),
                    .color(.textMuted),
                    .margin(.bottom(.rem(0.5)))
                )

            p { value }
                .styles(
                    .fontDisplay,
                    .fontSize(.clamp(min: .rem(1.5), ideal: .vw(4), max: .rem(2.0))),
                    .fontWeight(.regular),
                    .color(.text),
                    .lineHeight(1.1),
                    .margin(.bottom(.rem(0.5)))
                )

            p { trend }
                .styles(.fontSize(.rem(0.8125)), .color(.accent))
        }
        .styles(
            .backgroundColor(.bgSecondary),
            .borderRadius(.px(12)),
            .padding(.rem(1.25), .rem(1.0)),
            .textAlign(.left)
        )
    }
}
