import JavaScriptKit

private let storageKey = "adminAuthKey"

enum AuthStorage {
    static func save(_ key: String) {
        _ = JSObject.global.localStorage.setItem(storageKey.jsValue, key.jsValue)
    }

    static func load() -> String? {
        let value = JSObject.global.localStorage.getItem(storageKey.jsValue)
        guard let str = value.string, !str.isEmpty else { return nil }
        return str
    }

    static func clear() {
        _ = JSObject.global.localStorage.removeItem(storageKey.jsValue)
    }
}
