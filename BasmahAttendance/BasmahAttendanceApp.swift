import SwiftUI
import SwiftData

@main
struct BasmahAttendanceApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.layoutDirection, .rightToLeft)
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [EmployeeRecord.self, LeaveRequestRecord.self])
    }
}
