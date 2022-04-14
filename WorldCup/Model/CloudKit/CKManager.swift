//
//  CKManager.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

final class CKManager {
    
    static let shared = CKManager()
    
    func publishFromScratch(callback: @escaping (Result<String, WCError>) -> Void) {
        let stadiums = self.createStadiums()
        let groups = self.createGroups()
        let teamsAndTables = self.createTeamsAndTables(groups: groups)
        let teams = teamsAndTables.teams
        let tables = teamsAndTables.tables
        
        self.publishStadiums(stadiums) { [weak self] result in
            switch result {
            case .success(_):
                self?.publishGroups(groups: groups) { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.publishTeams(teams: teams) { [weak self] result in
                            switch result {
                            case .success(_):
                                self?.publishTables(tables: tables) { result in
                                    DispatchQueue.main.async {
                                        callback(result)
                                    }
                                }
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Stadiums
    
    private func publishStadiums(_ stadiums: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        CKStadium.publish(stadiums: self.createStadiums()) { result in
            callback(result)
        }
    }
    
    func fetchStadiums(callback: @escaping ([CKStadiumEntity]) -> Void) {
        CKStadium.fetch { result in
            switch result {
            case .success(let itens):
                DispatchQueue.main.async {
                    callback(itens)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeStadiums(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        CKStadium.removeAll(by: ids) { bool in
            callback(bool)
        }
    }
    
    // MARK: - Teams
    
    private func publishTeams(teams: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        CKTeams.publish(teams: teams) { result in
            callback(result)
        }
    }
    
    func fetchTeams(callback: @escaping ([CKTeamsEntity]) -> Void) {
        CKTeams.fetch { result in
            switch result {
            case .success(let itens):
                DispatchQueue.main.async {
                    callback(itens)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeTeams(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        CKTeams.removeAll(by: ids) { bool in
            callback(bool)
        }
    }
    
    // MARK: - Groups
    
    private func publishGroups(groups: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        CKGroups.publish(groups: groups) { result in
            callback(result)
        }
    }
    
    func fetchGroups(callback: @escaping ([CKGroupsEntity]) -> Void) {
        CKGroups.fetch { result in
            switch result {
            case .success(let itens):
                DispatchQueue.main.async {
                    callback(itens)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeGroups(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        CKGroups.removeAll(by: ids) { bool in
            callback(bool)
        }
    }
    
    // MARK: - Tables
    
    private func publishTables(tables: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        CKTables.publish(tables: tables) { result in
            callback(result)
        }
    }
    
    func fetchTables(callback: @escaping ([CKTablesEntity]) -> Void) {
        CKTables.fetch { result in
            switch result {
            case .success(let itens):
                DispatchQueue.main.async {
                    callback(itens)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func removeTables(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        CKTables.removeAll(by: ids) { bool in
            callback(bool)
        }
    }
    
    
    
    
    
    // MARK: - Players
    
    private func publishPlayers(callback: @escaping (Result<String, WCError>) -> Void) {
        let itens = [CKRecord]()
        CKPlayers.publish(players: itens) { result in
            callback(result)
        }
    }
    
    
    
    // MARK: - Matches
    
    private func publishMatches(callback: @escaping (Result<String, WCError>) -> Void) {
        let itens = [CKRecord]()
        CKMatches.publish(matches: itens) { result in
            callback(result)
        }
    }
}

extension CKManager {
    
    private func createStadiums() -> [CKRecord] {
        var itens = [CKRecord]()
        for value in EnumStadium.allCases {
            let item = CKRecord(recordType: RecordTypes.stadiums)
            item.setValue(UUID().uuidString, forKey: CKStadiumRecordKeys.id)
            item.setValue(value.name, forKey: CKStadiumRecordKeys.name)
            item.setValue(value.capacity, forKey: CKStadiumRecordKeys.capacity)
            item.setValue(value.location, forKey: CKStadiumRecordKeys.city)
            itens.append(item)
        }
        return itens
    }
    
    private func createGroups() -> [CKRecord] {
        var itens = [CKRecord]()
        for value in EnumGroups.allCases {
            let item = CKRecord(recordType: RecordTypes.groups)
            item.setValue(UUID().uuidString, forKey: CKGroupsRecordKeys.id)
            item.setValue(value.name, forKey: CKGroupsRecordKeys.name)
            item.setValue(value.index, forKey: CKGroupsRecordKeys.index)
            itens.append(item)
        }
        return itens
    }
    
    private func getGroupID(from groups: [CKRecord], by teamGroupID: Int) -> String? {
        let first = groups.first { record in
            guard let recordIndex = record[CKGroupsRecordKeys.index] as? Int else { return false }
            return recordIndex == teamGroupID
        }
        guard let first = first else { return nil }
        guard let recordIndex = first[CKGroupsRecordKeys.id] as? String else { return nil }
        return recordIndex
    }
    
    private func createTeamsAndTables(groups: [CKRecord]) -> (teams: [CKRecord], tables: [CKRecord]) {
        var itens = [CKRecord]()
        var tables = [CKRecord]()
        for value in EnumCountries.allCases {
            if let groupID = self.getGroupID(from: groups, by: value.groupID),
               value.groupPosition != 99 {
                let uuidString = UUID().uuidString
                let table = self.createTable(teamID: uuidString)
                tables.append(table.record)
                let item = CKRecord(recordType: RecordTypes.teams)
                item.setValue(uuidString, forKey: CKTeamsRecordKeys.id)
                item.setValue(value.name, forKey: CKTeamsRecordKeys.name)
                item.setValue("flag", forKey: CKTeamsRecordKeys.flag)
                item.setValue(groupID, forKey: CKTeamsRecordKeys.groupID)
                item.setValue(value.groupPosition, forKey: CKTeamsRecordKeys.groupPosition)
                item.setValue(value.fifaRank, forKey: CKTeamsRecordKeys.rank)
                item.setValue(table.uuidStringTable, forKey: CKTeamsRecordKeys.tableID)
                itens.append(item)
            }
        }
        return (itens, tables)
    }
    
    private func createTable(teamID: String) -> (uuidStringTable: String, record: CKRecord) {
        let uuidString = UUID().uuidString
        let item = CKRecord(recordType: RecordTypes.tables)
        item.setValue(uuidString, forKey: CKTablesRecordKeys.id)
        item.setValue(teamID, forKey: CKTablesRecordKeys.teamID)
        item.setValue(0, forKey: CKTablesRecordKeys.points)
        item.setValue(0, forKey: CKTablesRecordKeys.played)
        item.setValue(0, forKey: CKTablesRecordKeys.won)
        item.setValue(0, forKey: CKTablesRecordKeys.lost)
        item.setValue(0, forKey: CKTablesRecordKeys.draw)
        item.setValue(0, forKey: CKTablesRecordKeys.goalsAgainst)
        item.setValue(0, forKey: CKTablesRecordKeys.goalsFor)
        item.setValue(0, forKey: CKTablesRecordKeys.goalsDifference)
        return (uuidString, item)
    }
    
    private func createMatch(index: Int) -> CKRecord {
        let uuidString = UUID().uuidString
        let item = CKRecord(recordType: RecordTypes.matches)
        item.setValue(uuidString, forKey: CKMatchesRecordKeys.id)
        item.setValue(index, forKey: CKMatchesRecordKeys.index)
        item.setValue(0, forKey: CKMatchesRecordKeys.date)
        item.setValue(0, forKey: CKMatchesRecordKeys.goalsAway)
        item.setValue(0, forKey: CKMatchesRecordKeys.goalsHome)
        item.setValue("", forKey: CKMatchesRecordKeys.type)
        item.setValue("", forKey: CKMatchesRecordKeys.teamHomeID)
        item.setValue("", forKey: CKMatchesRecordKeys.teamAwayID)
        item.setValue("", forKey: CKMatchesRecordKeys.stadiumID)
        return item
    }

}
