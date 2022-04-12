//
//  Model.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import Foundation

//struct Country {
//    let id: UUID
//    let idFifa: Int
//    let name: String
//    let fifaRank: Int
//    var table: Table
//}
//
//extension Country {
//    init(name: String, fifaRank: Int) {
//        self.init(id: UUID(),
//                  idFifa: fifaRank,
//                  name: name,
//                  fifaRank: fifaRank,
//                  table: Table())
//    }
//}
//
//struct Table {
//    var points: Int
//    var played: Int
//    var win: Int
//    var draw: Int
//    var lost: Int
//    var goalsPro: Int
//    var goalsAgains: Int
//    var goalsSaldo: Int
//}
//
//extension Table {
//    init() {
//        self.init(points: 0, played: 0, win: 0, draw: 0, lost: 0, goalsPro: 0, goalsAgains: 0, goalsSaldo: 0)
//    }
//}
//
//struct Match {
//    let id: UUID
//    let idFifa: Int
//    let type: MatchType
//    let date: Date
//    let stadium: EnumStadium
//    let country1: Country
//    let country2: Country
//    var goalCountry1: Int
//    var goalCountry2: Int
//    var penalty: Int?
//
//    enum MatchType {
//        case group
//        case round16
//        case round8
//        case round4
//        case final
//        case third
//    }
//
//}
//
//extension Match {
//    init(idFifa: Int, type: MatchType, date: Date, stadium: EnumStadium, country1: Country, country2: Country) {
//        self.init(id: UUID(),
//                  idFifa: idFifa,
//                  type: type,
//                  date: date,
//                  stadium: stadium,
//                  country1: country1,
//                  country2: country2,
//                  goalCountry1: 0,
//                  goalCountry2: 0,
//                  penalty: nil)
//    }
//}
//
//struct Groups {
//    let id: UUID
//    let idFifa: Int
//    let name: String
//    let pos1: Country
//    let pos2: Country
//    let pos3: Country
//    let pos4: Country
//}
