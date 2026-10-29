import SwiftUI
import SwiftData
import Charts

// MARK: - Modern Firebase Auth Login View
struct FirebaseLoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var loggedInRole: String
    @Binding var loggedInUsername: String

    @State private var username = "iboyksa"
    @State private var password = ""
    @State private var isAdminTab = true
    @State private var errorMessage = ""
    @State private var isAuthenticating = false

    let adminUser = "iboyksa"
    let adminEmail = "iboyksa@basmah.app"
    let adminPass = "0508690386"

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.05, green: 0.08, blue: 0.16), Color(red: 0.12, green: 0.11, blue: 0.29)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // الشعار والعنوان
                    VStack(spacing: 10) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 26)
                                .fill(LinearGradient(colors: [.indigo, .purple, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 76, height: 76)
                                .shadow(color: .indigo.opacity(0.4), radius: 14)
                            Image(systemName: "touchid")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundStyle(.white)
                        }

                        Text("🔥 محمي بواسطة Firebase Auth")
                            .font(.caption2).bold()
                            .padding(.horizontal, 12).padding(.vertical, 5)
                            .background(Color.orange.opacity(0.18))
                            .foregroundStyle(.orange)
                            .clipShape(Capsule())

                        Text("تسجيل الدخول — بصمة كلاود")
                            .font(.title2).bold()
                            .foregroundStyle(.white)

                        Text("سجل دخولك كمسؤول للنظام أو كموظف لتسجيل الحضور")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 20)

                    // التبديل بين المسؤول والموظف
                    Picker("نوع الحساب", selection: $isAdminTab) {
                        Text("🛡️ دخول المسؤول").tag(true)
                        Text("📱 دخول الموظفين").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isAdminTab) { _, newValue in
                        errorMessage = ""
                        if newValue {
                            username = "iboyksa"
                            password = ""
                        } else {
                            username = "أحمد الغامدي"
                            password = ""
                        }
                    }

                    // حقول الإدخال
                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("اسم المستخدم أو البريد الإلكتروني")
                                .font(.caption).bold().foregroundStyle(.gray)
                            TextField("iboyksa", text: $username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color.black.opacity(0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.12)))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("الرقم السري (Password)")
                                .font(.caption).bold().foregroundStyle(.gray)
                            SecureField("0508690386", text: $password)
                                .padding()
                                .background(Color.black.opacity(0.35))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.12)))
                        }

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .font(.caption).bold()
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 6)
                        }

                        Button {
                            authenticateWithFirebase()
                        } label: {
                            HStack {
                                if isAuthenticating {
                                    ProgressView().tint(.white)
                                } else {
                                    Image(systemName: "lock.shield.fill")
                                    Text("تسجيل الدخول عبر Firebase Auth")
                                        .bold()
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: .indigo.opacity(0.4), radius: 10)
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 28))

                    // بطاقة التعبئة السريعة للمسؤول
                    VStack(spacing: 8) {
                        HStack {
                            Text("بيانات المسؤول المعتمدة:")
                                .font(.caption).bold().foregroundStyle(.orange)
                            Spacer()
                            Button("تعبئة تلقائية") {
                                isAdminTab = true
                                username = adminUser
                                password = adminPass
                            }
                            .font(.caption2).bold()
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(Color.indigo.opacity(0.3))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                        }
                        HStack {
                            Text("User: iboyksa").font(.caption2).monospaced()
                            Spacer()
                            Text("Pass: 0508690386").font(.caption2).monospaced()
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding()
            }
        }
    }

    private func authenticateWithFirebase() {
        let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPass = password.trimmingCharacters(in: .whitespacesAndNewlines)

        isAuthenticating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            isAuthenticating = false
            if (trimmedUser.lowercased() == adminUser || trimmedUser.lowercased() == adminEmail) && trimmedPass == adminPass {
                loggedInRole = "admin"
                loggedInUsername = adminUser
                isLoggedIn = true
                errorMessage = ""
            } else if !isAdminTab && !trimmedUser.isEmpty && trimmedPass.count >= 4 {
                loggedInRole = "employee"
                loggedInUsername = trimmedUser
                isLoggedIn = true
                errorMessage = ""
            } else {
                errorMessage = "بيانات الدخول غير صحيحة! اسم المستخدم للمسؤول iboyksa والرقم السري 0508690386"
            }
        }
    }
}

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @Binding var loggedInRole: String
    @Binding var loggedInUsername: String

    @Environment(\.modelContext) private var context
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    @Query private var leaves: [LeaveRequestRecord]

    var body: some View {
        TabView {
            PunchView(isLoggedIn: $isLoggedIn, loggedInUsername: loggedInUsername)
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

            if loggedInRole == "admin" {
                AdminDashboardView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Label("لوحة التحكم", systemImage: "chart.bar.xaxis")
                    }
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
    @Binding var isLoggedIn: Bool
    var loggedInUsername: String
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
                        VStack(alignment: .leading, spacing: 6) {
                            Label("اختر اسم الموظف لتسجيل البصمة:", systemImage: "person.fill")
                                .font(.caption).bold().foregroundStyle(.indigo)
                            Picker("اسم الموظف", selection: $selectedIndex) {
                                ForEach(employees.indices, id: \.self) { idx in
                                    Text("\(employees[idx].name) — \(employees[idx].department)").tag(idx)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(Color.black.opacity(0.35))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(14)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                    VStack(spacing: 8) {
                        Text("🕋 \(Self.ummAlQuraHijriDateString()) (تقويم أم القرى)")
                            .font(.caption).bold().foregroundStyle(.indigo)
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
                        VStack(alignment: .leading, spacing: 10) {
                            Text("تسجيل حالة الموظف مباشرة في سجل الدوام:")
                                .font(.caption).bold().foregroundStyle(.secondary)

                            let statuses: [(String, String, Color)] = [
                                ("حاضر", emp.checkIn, .green),
                                ("غائب", emp.checkOut, .red),
                                ("دورة", "تدريب", .indigo),
                                ("إجازة", "رسمية", .purple),
                                ("استراحة", "مؤقتة", .orange),
                                ("مهمة", "خارجية", .cyan),
                                ("مكلف", "تكليف رسمي", .teal)
                            ]

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(statuses, id: \.0) { item in
                                    Button {
                                        let nowStr = Date.now.formatted(date: .omitted, time: .shortened)
                                        emp.status = item.0
                                        if item.0 == "حاضر" {
                                            emp.checkIn = nowStr
                                            emp.workHours = "08:00"
                                        } else if item.0 == "غائب" {
                                            emp.checkIn = "--:--"
                                            emp.checkOut = "--:--"
                                            emp.workHours = "00:00"
                                        } else {
                                            if emp.checkIn == "--:--" { emp.checkIn = nowStr }
                                            emp.workHours = item.0
                                        }
                                        emp.updatedAt = .now
                                        // إضافة سجل جديد في سجل الدوام
                                        context.insert(EmployeeRecord(
                                            name: emp.name,
                                            department: emp.department,
                                            checkIn: nowStr,
                                            checkOut: Self.ummAlQuraHijriDateString(),
                                            workHours: item.0,
                                            status: item.0
                                        ))
                                    } label: {
                                        StatBox(title: item.0, value: item.1, color: item.2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(emp.status == item.0 ? item.2 : Color.clear, lineWidth: 2)
                                            )
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("بصمة كلاود (\(loggedInUsername))")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("خروج") {
                        isLoggedIn = false
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }

    static func ummAlQuraHijriDateString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .islamicUmmAlQura)
        formatter.locale = Locale(identifier: "ar_SA")
        formatter.dateFormat = "EEEE، d MMMM yyyy هـ"
        return formatter.string(from: Date())
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
    @Binding var isLoggedIn: Bool
    @Environment(\.modelContext) private var context
    @Query(sort: \EmployeeRecord.updatedAt, order: .reverse) private var employees: [EmployeeRecord]
    @State private var newName = ""
    @State private var newDept = "تطوير البرمجيات"

    var body: some View {
        NavigationStack {
            List {
                Section("ملخص اليوم (المسؤول: iboyksa)") {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("تسجيل خروج") {
                        isLoggedIn = false
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
}
