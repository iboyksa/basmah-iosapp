import SwiftUI
import SwiftData
import Charts

struct MainTabView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    @Query private var leaves: [LeaveRequestRecord]

    var body: some View {
        TabView {
            PunchView()
                .tabItem {
                    Label("البصمة", systemImage: "touchid")
                }

            LogsListView()
                .tabItem {
                    Label("سجل الدوام", systemImage: "list.clipboard.fill")
                }

            LeaveRequestView()
                .tabItem {
                    Label("الاستئذان", systemImage: "calendar.badge.plus")
                }

            AdminDashboardView()
                .tabItem {
                    Label("لوحة التحكم", systemImage: "chart.bar.xaxis")
                }
        }
        .tint(.indigo)
        .onAppear {
            seedDefaultDataIfNeeded()
        }
    }

    private func seedDefaultDataIfNeeded() {
        guard employees.isEmpty else { return }
        let samples = [
            EmployeeRecord(name: "أحمد الغامدي", department: "تطوير البرمجيات", checkIn: "07:55 AM", checkOut: "--:--", workHours: "06:35", status: "حاضر"),
            EmployeeRecord(name: "سارة القحطاني", department: "الموارد البشرية", checkIn: "08:02 AM", checkOut: "04:05 PM", workHours: "08:03", status: "منصرف"),
            EmployeeRecord(name: "خالد العتيبي", department: "المبيعات والتسويق", checkIn: "09:18 AM", checkOut: "--:--", workHours: "05:12", status: "متأخر"),
            EmployeeRecord(name: "نورة الدوسري", department: "الشؤون المالية", checkIn: "07:50 AM", checkOut: "04:00 PM", workHours: "08:10", status: "منصرف"),
            EmployeeRecord(name: "فهد الزهراني", department: "العمليات والجودة", checkIn: "--:--", checkOut: "--:--", workHours: "00:00", status: "غائب")
        ]
        samples.forEach { context.insert($0) }
    }
}

struct PunchView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    @State private var selectedIndex = 0

    var currentEmp: EmployeeRecord? {
        guard !employees.isEmpty, selectedIndex < employees.count else { return employees.first }
        return employees[selectedIndex]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    if !employees.isEmpty {
                        Picker("الموظف الحالي", selection: $selectedIndex) {
                            ForEach(employees.indices, id: \.self) { idx in
                                Text("\(employees[idx].name) - \(employees[idx].department)").tag(idx)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal)
                    }

                    VStack(spacing: 8) {
                        Text(Date.now.formatted(date: .complete, time: .omitted))
                            .font(.caption).foregroundStyle(.secondary)
                        Text(Date.now.formatted(date: .omitted, time: .standard))
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                        Label("داخل النطاق الجغرافي (جدة - المقر الرئيسي)", systemImage: "location.fill")
                            .font(.caption2).foregroundStyle(.green)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    Button {
                        guard let emp = currentEmp else { return }
                        let nowStr = Date.now.formatted(date: .omitted, time: .shortened)
                        if emp.status == "حاضر" || emp.status == "متأخر" {
                            emp.checkOut = nowStr
                            emp.workHours = "08:00"
                            emp.status = "منصرف"
                        } else {
                            emp.checkIn = nowStr
                            emp.checkOut = "--:--"
                            emp.workHours = "00:01"
                            emp.status = "حاضر"
                        }
                        emp.updatedAt = .now
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: "touchid")
                                .font(.system(size: 48))
                            Text((currentEmp?.status == "حاضر" || currentEmp?.status == "متأخر") ? "تسجيل انصراف" : "تسجيل حضور")
                                .font(.headline).bold()
                        }
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 170)
                        .background((currentEmp?.status == "حاضر" || currentEmp?.status == "متأخر") ? Color.orange.gradient : Color.green.gradient)
                        .clipShape(Circle())
                        .shadow(radius: 14)
                    }

                    if let emp = currentEmp {
                        HStack(spacing: 12) {
                            StatBox(title: "الحضور", value: emp.checkIn, color: .green)
                            StatBox(title: "الانصراف", value: emp.checkOut, color: .orange)
                            StatBox(title: "الساعات", value: emp.workHours, color: .indigo)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("بصمة كلاود")
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 6) {
            Text(title).font(.caption2).foregroundStyle(.secondary)
            Text(value).font(.subheadline).bold().foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct LogsListView: View {
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    var body: some View {
        NavigationStack {
            List(employees) { emp in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(emp.name).font(.headline)
                        Text(emp.department).font(.caption).foregroundStyle(.indigo)
                        Text("حضور: \(emp.checkIn) | انصراف: \(emp.checkOut)")
                            .font(.caption2).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(emp.status)
                        .font(.caption).bold()
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Color.indigo.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .navigationTitle("سجل الحضور والانصراف")
        }
    }
}

struct LeaveRequestView: View {
    @Environment(\.modelContext) private var context
    @Query private var leaves: [LeaveRequestRecord]
    @State private var empName = "أحمد الغامدي"
    @State private var leaveType = "استئذان ساعي"
    @State private var reason = ""

    let types = ["استئذان ساعي", "إجازة مرضية", "إجازة اعتيادية", "مهمة عمل خارجية"]

    var body: some View {
        NavigationStack {
            Form {
                Section("تقديم طلب جديد") {
                    TextField("اسم الموظف", text: $empName)
                    Picker("نوع الطلب", selection: $leaveType) {
                        ForEach(types, id: \.self) { Text($0) }
                    }
                    TextField("السبب والملاحظات", text: $reason)
                    Button("إرسال الطلب للإدارة") {
                        guard !reason.isEmpty else { return }
                        let req = LeaveRequestRecord(employeeName: empName, leaveType: leaveType, dateString: Date.now.formatted(date: .numeric, time: .omitted), reason: reason)
                        context.insert(req)
                        reason = ""
                    }
                    .bold()
                }

                Section("الطلبات السابقة") {
                    ForEach(leaves) { lv in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(lv.employeeName) - \(lv.leaveType)").font(.subheadline).bold()
                                Spacer()
                                Text(lv.approvalStatus).font(.caption).foregroundStyle(.orange)
                            }
                            Text(lv.reason).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("طلبات الاستئذان")
        }
    }
}

struct AdminDashboardView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    @State private var newName = ""
    @State private var newDept = "تطوير البرمجيات"

    var body: some View {
        NavigationStack {
            List {
                Section("ملخص اليوم") {
                    HStack {
                        StatBox(title: "الإجمالي", value: "\(employees.count)", color: .white)
                        StatBox(title: "حاضر/منصرف", value: "\(employees.filter { $0.status == "حاضر" || $0.status == "منصرف" }.count)", color: .green)
                        StatBox(title: "متأخر/غائب", value: "\(employees.filter { $0.status == "متأخر" || $0.status == "غائب" }.count)", color: .red)
                    }
                }

                Section("إضافة موظف لقاعدة البيانات") {
                    TextField("اسم الموظف الثلاثي", text: $newName)
                    TextField("القسم", text: $newDept)
                    Button("إضافة للقاعدة") {
                        guard !newName.isEmpty else { return }
                        context.insert(EmployeeRecord(name: newName, department: newDept, checkIn: "08:00 AM", status: "حاضر"))
                        newName = ""
                    }
                }

                Section("إدارة الموظفين (اضغط لتبديل الحالة)") {
                    ForEach(employees) { emp in
                        Button {
                            let states = ["حاضر", "منصرف", "متأخر", "غائب", "إجازة"]
                            if let idx = states.firstIndex(of: emp.status) {
                                emp.status = states[(idx + 1) % states.count]
                            } else {
                                emp.status = "حاضر"
                            }
                        } label: {
                            HStack {
                                Text(emp.name).foregroundStyle(.primary)
                                Spacer()
                                Text(emp.status).font(.caption).bold().foregroundStyle(.indigo)
                            }
                        }
                    }
                    .onDelete { offsets in
                        for i in offsets { context.delete(employees[i]) }
                    }
                }
            }
            .navigationTitle("لوحة التحكم")
        }
    }
}
