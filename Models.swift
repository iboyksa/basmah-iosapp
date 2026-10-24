import Foundation
import SwiftData

@Model
class EmployeeRecord {
    var id: UUID
    var name: String
    var department: String
    var checkIn: String
    var checkOut: String
    var workHours: String
    var status: String // حاضر، منصرف، متأخر، غائب، إجازة
    var updatedAt: Date

    init(name: String, department: String, checkIn: String = "--:--", checkOut: String = "--:--", workHours: String = "00:00", status: String = "لم يسجل") {
        self.id = UUID()
        self.name = name
        self.department = department
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.workHours = workHours
        self.status = status
        self.updatedAt = .now
    }
}

@Model
class LeaveRequestRecord {
    var id: UUID
    var employeeName: String
    var leaveType: String
    var dateString: String
    var reason: String
    var approvalStatus: String // قيد المراجعة، مقبول، مرفوض

    init(employeeName: String, leaveType: String, dateString: String, reason: String, approvalStatus: String = "قيد المراجعة") {
        self.id = UUID()
        self.employeeName = employeeName
        self.leaveType = leaveType
        self.dateString = dateString
        self.reason = reason
        self.approvalStatus = approvalStatus
    }
}
