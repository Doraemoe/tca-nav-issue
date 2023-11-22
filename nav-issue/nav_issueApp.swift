import ComposableArchitecture
import SwiftUI

@main
struct nav_issueApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppFeature.State()) {
                AppFeature()
            })
        }
    }
}
