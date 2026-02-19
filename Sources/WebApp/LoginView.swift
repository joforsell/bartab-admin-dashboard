import Foundation
import ElementaryUI


@View
struct LoginView {
    @Binding var adminKey: String?

    @State var inputKey: String = ""
    @State var isLoading: Bool = false
    @State var errorMessage: String? = nil

    var body: some View {
        div {
            div {
                img(.src("https://bartab.info/static/app-icon.svg"), .alt("Bartab"))
                    .width(.px(64)).height(.px(64))
                    .borderRadius(.px(14))
                    .boxShadow(y: 4, blur: 16, color: .rgb(r: 0, g: 0, b: 0, alpha: 0.12))
                    .margin(.px(0), .auto, .rem(1.5)).display(.block)

                h1 { "Admin Dashboard" }
                    .fontDisplay().fontWeight(.regular).fontSize(.rem(1.75))
                    .letterSpacing(.em(-0.02)).textAlign(.center).margin(bottom: .rem(0.5))

                p { "Enter your password to continue" }
                    .textAlign(.center).fontSize(.rem(0.875)).color(.textMuted).margin(bottom: .rem(2))

                div {
                    label { "Password" }
                        .display(.block)
                        .fontSize(.rem(0.75))
                        .fontWeight(.semiBold)
                        .textTransform(.uppercase)
                        .letterSpacing(.em(0.05))
                        .color(.textMuted)
                        .margin(bottom: .rem(0.5))

                    input(.type(.password), .placeholder("Enter password"))
                        .width(.percent(100))
                        .padding(.rem(0.75))
                        .fontSize(.rem(1))
                        .backgroundColor(.bg)
                        .border(.solid(color: .border))
                        .borderRadius(.px(8))
                        .color(.text)
                        .margin(bottom: .rem(1))
                        .outline(.none)
                        .bindValue($inputKey)

                    if let error = errorMessage {
                        p { error }
                            .fontSize(.rem(0.8125)).color(.error).margin(bottom: .rem(1))
                    }

                    button { isLoading ? "Signing in..." : "Sign In" }
                        .width(.percent(100)).padding(.rem(0.75)).fontSize(.rem(1))
                        .fontWeight(.medium).backgroundColor(.text).color(.bg)
                        .border(.none).borderRadius(.px(8))
                        .opacity(isLoading ? 0.6 : 1)
                        .cursor(isLoading ? .notAllowed : .pointer)
                        .onClick { _ in
                            guard !isLoading, !inputKey.isEmpty else { return }
                            let password = inputKey
                            Task { await login(password: password) }
                        }
                }
                .backgroundColor(.bgSecondary)
                .border(.solid(color: .border))
                .borderRadius(.px(12)).padding(.rem(1.5))
            }
            .width(.percent(100)).maxWidth(.px(380))
        }
        .minHeight(.vh(100)).display(.flex).alignItems(.center).justifyContent(.center)
        .backgroundColor(.bg).padding(.rem(1))
    }

    private func login(password: String) async {
        isLoading = true
        errorMessage = nil

        struct LoginRequest: Encodable { let password: String }
        let request = FetchRequest(
            method: .post,
            body: LoginRequest(password: password)
        )

        do {
            let response = try await request.send(to: "\(backendURL)/admin/login")

            isLoading = false

            guard response.status == 200 else {
                errorMessage = response.status == 401 ? "Invalid password." : "Unexpected error (HTTP \(response.status))."
                return
            }

            struct TokenResponse: Decodable { let token: String }
            let token = try response.decode(TokenResponse.self).token

            AuthStorage.save(token)
            adminKey = token
        } catch {
            isLoading = false
            errorMessage = "Request failed: \(error)"
        }
    }
}
