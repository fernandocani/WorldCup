//
//  PasswordView.swift
//  WorldCup
//
//  Created by Fernando Cani on 17/04/22.
//

import SwiftUI

struct ContentView: View {
    
    var dismiss: (() -> Void)
    
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("close") {
                        self.dismiss()
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}

struct Home : View {
    
    @State var unLocked = false
    
    var body: some View {
        ZStack{
            if unLocked {
                UnlockedScreen()
            } else {
                LockScreen(unLocked: $unLocked)
            }
        }
    }
    
}

struct UnlockedScreen : View {
    
    @State private var showingAlert = false
    @State var loading: Bool = false
    @State private var alertMessage: String = String()
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("All")
                        .font(.title2)
                        .fontWeight(.heavy)
                    HStack {
                        Button("Publish") {
                            self.publish()
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Fetch") {
                            self.fetchAll()
                        }
                        .buttonStyle(.borderedProminent)
                        Button("Remove") {
                            self.removeAll()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .alert("Result", isPresented: $showingAlert) {
                        Button("OK", action: {
                            alertMessage = String()
                        })
                    } message: {
                        Text(alertMessage)
                    }
                }
                ForEach(RecordTypes.allCases, id: \.self) { value in
                    let type = value as RecordTypes
                    VStack {
                        Text(type.title)
                            .font(.title2)
                            .fontWeight(.heavy)
                        HStack {
                            Button("Fetch") {
                                self.fetch(type: type)
                            }
                            .buttonStyle(.borderedProminent)
                            Button("Remove") {
                                self.remove(type: type)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .alert("Result", isPresented: $showingAlert) {
                            Button("OK", action: {
                                alertMessage = String()
                            })
                        } message: {
                            Text(alertMessage)
                        }
                    }
                }
                Spacer()
            }
            .padding(.top)
            if loading {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 140, height: 140, alignment: .center)
                    .cornerRadius(20)
                ProgressView("Loading")
                    .font(Font.title3)
                    .foregroundColor(Color.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        }
    }
    
    private func publish() {
        Task {
            self.setLoading(bool: true)
            let result = await CKManager.shared.publishFromScratch()
            switch result {
            case .success(_):
                print("Success -publishFromScratch")
                alertMessage = "publishFromScratch success"
                self.setLoading(bool: false)
                self.showingAlert = true
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
                           
    private func fetch(type: RecordTypes) {
        print(#function, type)
        Task {
            self.setLoading(bool: true)
            switch type {
            case .groups:
                let itens    = await CKManager.shared.fetchGroups()
                alertMessage = "Groups: \(itens.count) values"
            case .matches:
                let itens    = await CKManager.shared.fetchMatches()
                alertMessage = "Matches: \(itens.count) values"
            case .stadiums:
                let itens    = await CKManager.shared.fetchStadiums()
                alertMessage = "Stadiums: \(itens.count) values"
            case .teams:
                let itens    = await CKManager.shared.fetchTeams()
                alertMessage = "Teams: \(itens.count) values"
            case .tables:
                let itens    = await CKManager.shared.fetchTables()
                alertMessage = "Tables: \(itens.count) values"
            }
            self.setLoading(bool: false)
            self.showingAlert = true
        }
    }
    
    private func fetchAll() {
        print(#function)
        Task {
            self.setLoading(bool: true)
            let groups = await CKManager.shared.fetchGroups()
            let teams = await CKManager.shared.fetchTeams()
            let stadiums = await CKManager.shared.fetchStadiums()
            let tables = await CKManager.shared.fetchTables()
            let matches = await CKManager.shared.fetchMatches()
            alertMessage = """
                        Groups: \(groups.count)
                        Teams: \(teams.count)
                        Stadiums: \(stadiums.count)
                        Tables: \(tables.count)
                        Matches: \(matches.count)
                        """
            self.setLoading(bool: false)
            self.showingAlert = true
        }
    }
    
    private func remove(type: RecordTypes) {
        print(#function, type.title)
        Task {
            self.setLoading(bool: true)
            switch type {
            case .groups:
                let groups = await CKManager.shared.fetchGroups()
                let groupIDS = groups.map({ $0.recordID! })
                let boolGroups = await CKManager.shared.removeGroups(by: groupIDS)
                alertMessage = "removeGroups \(boolGroups)"
            case .matches:
                let matches = await CKManager.shared.fetchMatches()
                let matchesIDS = matches.map({ $0.recordID! })
                let boolMatches = await CKManager.shared.removeMatches(by: matchesIDS)
                alertMessage = "removeMatches \(boolMatches)"
            case .stadiums:
                let stadiums = await CKManager.shared.fetchStadiums()
                let stadiumsIDS = stadiums.map({ $0.recordID! })
                let boolStadiums = await CKManager.shared.removeStadiums(by: stadiumsIDS)
                alertMessage = "removeStadiums \(boolStadiums)"
            case .teams:
                let teams = await CKManager.shared.fetchTeams()
                let teamsIDS = teams.map({ $0.recordID! })
                let boolTeams = await CKManager.shared.removeTeams(by: teamsIDS)
                alertMessage = "removeTeams \(boolTeams)"
            case .tables:
                let tables = await CKManager.shared.fetchTables()
                let tablesIDS = tables.map({ $0.recordID! })
                let boolTables = await CKManager.shared.removeTables(by: tablesIDS)
                alertMessage = "removeTables \(boolTables)"
            }
            self.setLoading(bool: false)
            self.showingAlert = true
        }
        
    }
    
    private func removeAll() {
        print(#function)
        Task {
            self.setLoading(bool: true)
            let groups = await CKManager.shared.fetchGroups()
            let teams = await CKManager.shared.fetchTeams()
            let stadiums = await CKManager.shared.fetchStadiums()
            let tables = await CKManager.shared.fetchTables()
            let matches = await CKManager.shared.fetchMatches()
            
            let groupIDS = groups.map({ $0.recordID! })
            let teamsIDS = teams.map({ $0.recordID! })
            let stadiumsIDS = stadiums.map({ $0.recordID! })
            let tablesIDS = tables.map({ $0.recordID! })
            let matchesIDS = matches.map({ $0.recordID! })
            
            let boolGroups = await CKManager.shared.removeGroups(by: groupIDS)
            let boolTeams = await CKManager.shared.removeTeams(by: teamsIDS)
            let boolStadiums = await CKManager.shared.removeStadiums(by: stadiumsIDS)
            let boolTables = await CKManager.shared.removeTables(by: tablesIDS)
            let boolMatches = await CKManager.shared.removeMatches(by: matchesIDS)
            
            alertMessage = """
                           Groups: \(boolGroups)
                           Teams: \(boolTeams)
                           Stadiums: \(boolStadiums)
                           Tables: \(boolTables)
                           Matches: \(boolMatches)
                           """
            
            self.setLoading(bool: false)
            self.showingAlert = true
        }
        
    }
    
    func setLoading(bool: Bool) {
        DispatchQueue.main.async {
            self.loading = bool
        }
    }
    
}

struct LockScreen : View {
    
    @State var password = ""
    @AppStorage("lock_Password") var key = "0000"
    @Binding var unLocked : Bool
    @State var wrongPassword = false
    
    let height = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
            Text("Enter Pin <\(key)> to Unlock")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top, 20)
            HStack(spacing: 22) {
                // Password Circle View...
                ForEach(0..<key.count,id: \.self) { index in
                    PasswordView(index: index, password: $password)
                }
            }
            if wrongPassword {
                Spacer()
                Text("Incorrect Pin")
                    .foregroundColor(.red)
                    .fontWeight(.heavy)
            }
            Spacer()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3),
                      spacing: 20) {
                ForEach(1...9, id: \.self) { value in
                    PasswordButton(value: "\(value)",
                                   password: $password,
                                   key: $key,
                                   unlocked: $unLocked,
                                   wrongPass: $wrongPassword)
                }
                PasswordButton(value: "delete.fill",
                               password: $password,
                               key: $key,
                               unlocked: $unLocked,
                               wrongPass: $wrongPassword)
                PasswordButton(value: "0",
                               password: $password,
                               key: $key,
                               unlocked: $unLocked,
                               wrongPass: $wrongPassword)
            }
            .padding(.bottom, 8)
        }
        .padding()
    }
}

struct PasswordView : View {
    
    var index : Int
    @Binding var password : String
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(Color.primary, lineWidth: 2)
                .frame(width: 30, height: 30)
            // checking whether it is typed...
            if password.count > index {
                Circle()
                    .fill(Color.primary)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct PasswordButton : View {
    
    var value : String
    @Binding var password : String
    @Binding var key : String
    @Binding var unlocked : Bool
    @Binding var wrongPass : Bool
    
    let size: CGFloat = 100
    
    var body: some View{
        Button(action: setPassword, label: {
            VStack{
                if value.count > 1 {
                    // Image...
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                } else {
                    Text(value)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .frame(width: size, height: size, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: size / 2)
                    .stroke(Color.primary, lineWidth: 2)
            )
            .cornerRadius(size / 2)
        })
    }
    
    private func setPassword() {
        // checking if backspace pressed...
        withAnimation{
            if value.count > 1{
                if password.count != 0 {
                    password.removeLast()
                }
            } else {
                if password.count != key.count {
                    password.append(value)
                    // Delay Animation...
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation{
                            if password.count == key.count {
                                if password == key {
                                    unlocked = true
                                } else {
                                    wrongPass = true
                                    password.removeAll()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Password_Previews: PreviewProvider {
    static var previews: some View {
        //UnlockedScreen(loading: true)
        ContentView(dismiss: { })
            .preferredColorScheme(.dark)
            //.preferredColorScheme(.light)
        //ContentView()
        //LockScreen(unLocked: .constant(false))
        //KeypadView(unLocked: .constant(false))
        
        //LockScreen(unLocked: .constant(false))
        //    .preferredColorScheme(.dark)
        //UnlockedScreen()
        //    .preferredColorScheme(.dark)
    }
}
