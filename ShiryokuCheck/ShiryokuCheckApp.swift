import SwiftUI

@main
struct ShiryokuCheckApp: App {
    @StateObject private var testManager = VisionTestManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(testManager)
        }
    }
}
