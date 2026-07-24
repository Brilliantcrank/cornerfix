import Foundation

/// Reads and writes the undocumented NSGlobalDomain preference keys macOS Tahoe
/// uses for window and sidebar corner radius. Equivalent to `defaults write -g`.
enum CornerRadiusManager {
    static let windowRadiusKey = "NSConvolutionOverride1"
    static let sidebarRadiusKey = "NSSplitViewItemGlassMinimumCornerRadius"
    static let floatingSidebarKey = "NSSplitViewItemSidebarDefaultsToFloatingAppearance"

    // Matches the pre-Tahoe (Sequoia / macOS 15) look.
    static let classicWindowRadius: Float = 10
    static let classicSidebarRadius: Float = 10

    private static func globalDomain() -> [String: Any] {
        UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) ?? [:]
    }

    private static func setGlobalDomain(_ domain: [String: Any]) {
        UserDefaults.standard.setPersistentDomain(domain, forName: UserDefaults.globalDomain)
        UserDefaults.standard.synchronize()
    }

    static func currentWindowRadius() -> Float? {
        (globalDomain()[windowRadiusKey] as? NSNumber)?.floatValue
    }

    static func currentSidebarRadius() -> Float? {
        (globalDomain()[sidebarRadiusKey] as? NSNumber)?.floatValue
    }

    static func currentFloatingSidebar() -> Bool? {
        (globalDomain()[floatingSidebarKey] as? NSNumber)?.boolValue
    }

    static func applyClassic() {
        applyCustom(windowRadius: classicWindowRadius, sidebarRadius: classicSidebarRadius, floatingSidebar: false)
    }

    static func resetToSystemDefault() {
        var domain = globalDomain()
        domain.removeValue(forKey: windowRadiusKey)
        domain.removeValue(forKey: sidebarRadiusKey)
        domain.removeValue(forKey: floatingSidebarKey)
        setGlobalDomain(domain)
    }

    static func applyCustom(windowRadius: Float, sidebarRadius: Float, floatingSidebar: Bool) {
        var domain = globalDomain()
        domain[windowRadiusKey] = windowRadius
        domain[sidebarRadiusKey] = sidebarRadius
        domain[floatingSidebarKey] = floatingSidebar
        setGlobalDomain(domain)
    }

    @discardableResult
    static func relaunchFinder() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
        task.arguments = ["Finder"]
        do {
            try task.run()
            return true
        } catch {
            return false
        }
    }
}
