import SwiftUI

@main
struct ShiryokuCheckApp: App {
    @StateObject private var testManager = VisionTestManager()
    @StateObject private var adMob = AdMobManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(testManager)
                .onAppear { adMob.configure() }
        }
    }
}
