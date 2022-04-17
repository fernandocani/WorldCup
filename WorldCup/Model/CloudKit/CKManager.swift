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
    
    func publishFromScratch() async -> Result<Bool, WCError> {
        var stadiumsEntity  = self.createStadiums()
        var groupsEntity    = self.createGroups()
        var teamsEntity     = self.createTeams()
        var tablesEntity    = self.createTables(teams: teamsEntity)
        var matchesEntity   = self.createMatches()
        print("--in")
        self.fixObjects(stadiums: &stadiumsEntity,
                        groups: &groupsEntity,
                        teams: &teamsEntity,
                        tables: &tablesEntity,
                        matches: &matchesEntity)
        print("--out")
        let stadiums        = self.convertEntityToCK(originals: stadiumsEntity)
        let groups          = self.convertEntityToCK(originals: groupsEntity)
        let teams           = self.convertEntityToCK(originals: teamsEntity)
        let tables          = self.convertEntityToCK(originals: tablesEntity)
        let matches         = self.convertEntityToCK(originals: matchesEntity)
        
        let boolStadiums    = await self.publishStadiums(stadiums: stadiums)
        let boolGroups      = await self.publishGroups(groups: groups)
        let boolTeams       = await self.publishTeams(teams: teams)
        let boolTables      = await self.publishTables(tables: tables)
        let boolMatches     = await self.publishMatches(matches: matches)
        guard boolStadiums,
              boolGroups,
              boolTeams,
              boolTables,
              boolMatches
        else { return .failure(WCError.ParseFailed) }
        return .success(true)
    }
    
    // MARK: - Stadiums
    
    func publishStadiums(stadiums: [CKRecord]? = nil) async -> Bool {
        let result = await CKStadium.publish(itens: stadiums ?? self.convertEntityToCK(originals: self.createStadiums()))
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchStadiums() async -> [CKStadiumEntity] {
        let result = await CKStadium.fetch()
        switch result {
        case .success(let itens):
            return itens
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func removeStadiums(by ids: [CKRecord.ID]) async -> Bool {
        let result = await CKStadium.removeAll(by: ids)
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Teams
    
    private func publishTeams(teams: [CKRecord]? = nil) async -> Bool {
        let result = await CKTeams.publish(itens: teams ?? self.convertEntityToCK(originals: self.createStadiums()))
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTeams() async -> [CKTeamsEntity] {
        let result = await CKTeams.fetch()
        switch result {
        case .success(let itens):
            return itens
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func removeTeams(by ids: [CKRecord.ID]) async -> Bool {
        let result = await CKTeams.removeAll(by: ids)
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Groups
    
    private func publishGroups(groups: [CKRecord]? = nil) async -> Bool {
        let result = await CKGroups.publish(itens: groups ?? self.convertEntityToCK(originals: self.createStadiums()))
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchGroups() async -> [CKGroupsEntity] {
        let result = await CKGroups.fetch()
        switch result {
        case .success(let itens):
            return itens
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func removeGroups(by ids: [CKRecord.ID]) async -> Bool {
        let result = await CKGroups.removeAll(by: ids)
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Tables
    
    private func publishTables(tables: [CKRecord]? = nil) async -> Bool {
        let result = await CKTables.publish(itens: tables ?? self.convertEntityToCK(originals: self.createStadiums()))
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchTables() async -> [CKTablesEntity] {
        let result = await CKTables.fetch()
        switch result {
        case .success(let itens):
            return itens
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func removeTables(by ids: [CKRecord.ID]) async -> Bool {
        let result = await CKTables.removeAll(by: ids)
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Matches
    
    private func publishMatches(matches: [CKRecord]? = nil) async -> Bool {
        let result = await CKMatches.publish(itens: matches ?? self.convertEntityToCK(originals: self.createMatches()))
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchMatches() async -> [CKMatchesEntity] {
        let result = await CKMatches.fetch()
        switch result {
        case .success(let itens):
            return itens
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    func removeMatches(by ids: [CKRecord.ID]) async -> Bool {
        let result = await CKMatches.removeAll(by: ids)
        switch result {
        case .success(let bool):
            return bool
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
}

extension CKManager {
    
    private func convertEntityToCK(originals: [Any]) -> [CKRecord] {
        var itens = [CKRecord]()
        switch originals {
        case let (array as [CKStadiumEntity]) as Any:
            for value in array {
                let item = CKRecord(recordType: RecordTypes.stadiums, recordID: CKRecord.ID(recordName: value.id))
                item.setValue(value.id,             forKey: CKStadiumRecordKeys.id)
                item.setValue(value.name,           forKey: CKStadiumRecordKeys.name)
                item.setValue(value.capacity,       forKey: CKStadiumRecordKeys.capacity)
                item.setValue(value.city,           forKey: CKStadiumRecordKeys.city)
                item.setValue(value.index,          forKey: CKStadiumRecordKeys.index)
                itens.append(item)
            }
        case let (array as [CKTeamsEntity]) as Any:
            for value in array {
                let item = CKRecord(recordType: RecordTypes.teams, recordID: CKRecord.ID(recordName: value.id))
                item.setValue(value.id,             forKey: CKTeamsRecordKeys.id)
                item.setValue(value.name,           forKey: CKTeamsRecordKeys.name)
                item.setValue(value.flag,           forKey: CKTeamsRecordKeys.flag)
                item.setValue(value.groupID,        forKey: CKTeamsRecordKeys.groupID)
                item.setValue(value.groupPosition,  forKey: CKTeamsRecordKeys.groupPosition)
                item.setValue(value.rank,           forKey: CKTeamsRecordKeys.rank)
                item.setValue(value.tableID,        forKey: CKTeamsRecordKeys.tableID)
                itens.append(item)
            }
        case let (array as [CKTablesEntity]) as Any:
            for value in array {
                let item = CKRecord(recordType: RecordTypes.tables, recordID: CKRecord.ID(recordName: value.id))
                item.setValue(value.id,             forKey: CKTablesRecordKeys.id)
                item.setValue(value.teamID,         forKey: CKTablesRecordKeys.teamID)
                item.setValue(value.points,         forKey: CKTablesRecordKeys.points)
                item.setValue(value.played,         forKey: CKTablesRecordKeys.played)
                item.setValue(value.won,            forKey: CKTablesRecordKeys.won)
                item.setValue(value.lost,           forKey: CKTablesRecordKeys.lost)
                item.setValue(value.draw,           forKey: CKTablesRecordKeys.draw)
                item.setValue(value.goalsAgainst,   forKey: CKTablesRecordKeys.goalsAgainst)
                item.setValue(value.goalsFor,       forKey: CKTablesRecordKeys.goalsFor)
                item.setValue(value.goalsDifference,forKey: CKTablesRecordKeys.goalsDifference)
                itens.append(item)
            }
        case let (array as [CKMatchesEntity]) as Any:
            for value in array {
                let item = CKRecord(recordType: RecordTypes.matches, recordID: CKRecord.ID(recordName: value.id))
                item.setValue(value.id,             forKey: CKMatchesRecordKeys.id)
                item.setValue(value.index,          forKey: CKMatchesRecordKeys.index)
                item.setValue(value.teamHomeID,     forKey: CKMatchesRecordKeys.teamHomeID)
                item.setValue(value.teamAwayID,     forKey: CKMatchesRecordKeys.teamAwayID)
                item.setValue(value.stadiumID,      forKey: CKMatchesRecordKeys.stadiumID)
                item.setValue(value.date,           forKey: CKMatchesRecordKeys.date)
                item.setValue(value.goalsAway,      forKey: CKMatchesRecordKeys.goalsAway)
                item.setValue(value.goalsHome,      forKey: CKMatchesRecordKeys.goalsHome)
                item.setValue(value.type,           forKey: CKMatchesRecordKeys.type)
                itens.append(item)
            }
        case let (array as [CKGroupsEntity]) as Any:
            for value in array {
                let item = CKRecord(recordType: RecordTypes.groups, recordID: CKRecord.ID(recordName: value.id))
                item.setValue(value.id,             forKey: CKGroupsRecordKeys.id)
                item.setValue(value.name,           forKey: CKGroupsRecordKeys.name)
                item.setValue(value.index,          forKey: CKGroupsRecordKeys.index)
                itens.append(item)
            }
        default: break
        }
        return itens
    }
    
    private func createStadiums() -> [CKStadiumEntity] {
        var itens = [CKStadiumEntity]()
        for value in EnumStadium.allCases {
            let uuidString = UUID().uuidString
            let item = CKStadiumEntity(id: uuidString,
                                       name: value.name,
                                       capacity: value.capacity,
                                       city: value.location,
                                       index: value.index)
            itens.append(item)
        }
        return itens
    }
    
    private func createGroups() -> [CKGroupsEntity] {
        var itens = [CKGroupsEntity]()
        for value in EnumGroups.allCases {
            let uuidString = UUID().uuidString
            let item = CKGroupsEntity(id: uuidString,
                                      name: value.name,
                                      index: value.index)
            itens.append(item)
        }
        return itens
    }
    
    private func createTeams() -> [CKTeamsEntity] {
        var itens = [CKTeamsEntity]()
        for value in EnumCountries.allCases.filter({ $0.groupPosition != 99 }) {
            let uuidString = UUID().uuidString
            let item = CKTeamsEntity(id: uuidString,
                                     name: value.name,
                                     flag: value.flag,
                                     groupID: "\(value.groupID)",
                                     groupPosition: value.groupPosition,
                                     rank: value.fifaRank,
                                     tableID: "tableID")
            itens.append(item)
        }
        return itens
    }
    
    private func createTables(teams: [CKTeamsEntity]? = nil) -> [CKTablesEntity] {
        var itens = [CKTablesEntity]()
        if let teams = teams {
            for team in teams {
                let uuidString = UUID().uuidString
                let item = CKTablesEntity(id: uuidString,
                                          teamID: team.id,
                                          points: 0,
                                          played: 0,
                                          won: 0,
                                          lost: 0,
                                          draw: 0,
                                          goalsAgainst: 0,
                                          goalsFor: 0,
                                          goalsDifference: 0)
                itens.append(item)
            }
        } else {
            for _ in 1...EnumCountries.allCases.filter({ $0.groupPosition != 99 }).count {
                let uuidString = UUID().uuidString
                let item = CKTablesEntity(id: uuidString,
                                          teamID: "teamID",
                                          points: 0,
                                          played: 0,
                                          won: 0,
                                          lost: 0,
                                          draw: 0,
                                          goalsAgainst: 0,
                                          goalsFor: 0,
                                          goalsDifference: 0)
                itens.append(item)
            }
        }
        return itens
    }
    
    private func createMatches() -> [CKMatchesEntity] {
        var itens = [CKMatchesEntity]()
        for value in MatchesConstructor.allCases {
            let uuidString = UUID().uuidString
            let item = CKMatchesEntity(id: uuidString,
                                       index: value.index,
                                       teamHomeID: value.homeTeam,
                                       teamAwayID: value.awayTeam,
                                       stadiumID: "\(value.stadium)",
                                       date: value.dateTime.toDate() ?? Date(),
                                       goalsAway: 0,
                                       goalsHome: 0,
                                       type: value.type)
            itens.append(item)
        }
        return itens
    }
    
    private func fixObjects(stadiums: inout [CKStadiumEntity],
                            groups: inout [CKGroupsEntity],
                            teams: inout [CKTeamsEntity],
                            tables: inout [CKTablesEntity],
                            matches: inout [CKMatchesEntity]) {
        //Fix Teams and Tables
        for (index, team) in teams.enumerated() {
            if let group = groups.first(where: { "\($0.index)" == team.groupID }) {
                teams[index].groupID = group.id
            }
            if let table = tables.first(where: { $0.teamID == "teamID" }) {
                teams[index].tableID = table.id
                tables[index].teamID = team.id
            }
        }
        //Fix Matches
        var groupsIDSDict: [String: String] = [:]
        for group in groups {
            if let index = group.index.getGroupID() {
                groupsIDSDict["\(index)"] = group.id
            }
        }
        for (index, match) in matches.enumerated() {
            if let stadium = stadiums.first(where: { "\($0.index)" == match.stadiumID }) {
                matches[index].stadiumID = stadium.id
            }
            switch MatchType(rawValue: match.type) {
            case .group:
                if let first = match.teamHomeID.first,
                   let last = match.teamHomeID.last,
                   let groupPosition = Int(last.description),
                   let groupID = groupsIDSDict[String(first)],
                   let team = teams.first(where: { $0.groupID == groupID && $0.groupPosition == groupPosition }) {
                    matches[index].teamHomeID = team.id
                }
                if let first = match.teamAwayID.first,
                   let last = match.teamAwayID.last,
                   let groupPosition = Int(last.description),
                   let groupID = groupsIDSDict[String(first)],
                   let team = teams.first(where: { $0.groupID == groupID && $0.groupPosition == groupPosition }) {
                    matches[index].teamAwayID = team.id
                }
            case .roundOf16:    print("roundOf16")
            case .roundOf8:     print("roundOf8")
            case .semifinal:    print("semifinal")
            case .thirdPlace:   print("thirdPlace")
            case .final:        print("final")
            case .none: break
            }
        }
    }

}
