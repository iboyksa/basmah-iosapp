import SwiftUI
import SwiftData

@main
struct BasmahAttendanceApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("loggedInRole") private var loggedInRole = "admin" // admin or employee
    @AppStorage("loggedInUsername") private var loggedInUsername = "iboyksa"

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    MainTabView(isLoggedIn: $isLoggedIn, loggedInRole: $loggedInRole, loggedInUsername: $loggedInUsername)
                } else {
                    FirebaseLoginView(isLoggedIn: $isLoggedIn, loggedInRole: $loggedInRole, loggedInUsername: $loggedInUsername)
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .preferredColorScheme(.dark)
        }
        .modelContainer(for: [EmployeeRecord.self, LeaveRequestRecord.self])
    }
}
