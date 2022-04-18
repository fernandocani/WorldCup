//
//  CKConstants.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

enum RecordTypes: CaseIterable {
    case groups
    case matches
    case stadiums
    case teams
    case tables
    
    var title: String {
        switch self {
        case .groups:   return "Groups"
        case .matches:  return "Matches"
        case .stadiums: return "Stadiums"
        case .teams:    return "Teams"
        case .tables:   return "Tables"
        }
    }
}

extension CKManager {
    
    enum EnumCountries: CaseIterable {
        //https://www.fifa.com/fifa-world-ranking
        //https://www.fifa.com/tournaments/mens/worldcup/qatar2022
        //https://flagicons.lipis.dev
        case argentina
        case belgium
        case brazil
        case canada
        case cameroon
        case croatia
        case denmark
        case ecuador
        case england
        case france
        case germany
        case ghana
        case iran
        case japan
        case korea
        case morocco
        case mexico
        case netherlands
        case poland
        case portugal
        case qatar
        case saudiArabia
        case spain
        case senegal
        case serbia
        case switzerland
        case tunisia
        case usa
        case uruguai
        case EUR
        case PL1
        case PL2
        case wales
        case scotland
        case ukraine
        case peru
        case australia
        case arabEmirates
        case costaRica
        case newZeland

        var name: String {
            switch self {
            case .argentina:    return "Argentina"
            case .belgium:      return "Belgium"
            case .brazil:       return "Brazil"
            case .canada:       return "Canada"
            case .cameroon:     return "Cameroon"
            case .croatia:      return "Croatia"
            case .denmark:      return "Denmark"
            case .ecuador:      return "Ecuador"
            case .england:      return "England"
            case .france:       return "France"
            case .germany:      return "Germany"
            case .ghana:        return "Ghana"
            case .iran:         return "IR Iran"
            case .japan:        return "Japan"
            case .korea:        return "Korea Republic"
            case .morocco:      return "Morocco"
            case .mexico:       return "Mexico"
            case .netherlands:  return "Netherland"
            case .poland:       return "Poland"
            case .portugal:     return "Portugal"
            case .qatar:        return "Qatar"
            case .saudiArabia:  return "Saudi Arabia"
            case .spain:        return "Spain"
            case .senegal:      return "Senegal"
            case .serbia:       return "Serbia"
            case .switzerland:  return "Switzerland"
            case .tunisia:      return "Tunisia"
            case .usa:          return "USA"
            case .uruguai:      return "Uruguai"
            case .EUR:          return "EUR - Gales/Scotland/Ukraine"
            case .PL1:          return "PL1 - Peru/Australia/United Arab Emirates"
            case .PL2:          return "PL2 - Costa Rica/New Zeland"
            case .wales:        return "Wales"
            case .scotland:     return "Scotland"
            case .ukraine:      return "Ukraine"
            case .peru:         return "Peru"
            case .australia:    return "Australia"
            case .arabEmirates: return "United Arab Emirates"
            case .costaRica:    return "Costa Rica"
            case .newZeland:    return "New Zeland"
            }
        }

        var fifaRank: Int {
            switch self {
            case .argentina:    return 4
            case .belgium:      return 2
            case .brazil:       return 1
            case .canada:       return 38
            case .cameroon:     return 37
            case .croatia:      return 16
            case .denmark:      return 11
            case .ecuador:      return 46
            case .england:      return 5
            case .france:       return 3
            case .germany:      return 12
            case .ghana:        return 60
            case .iran:         return 21
            case .japan:        return 23
            case .korea:        return 29
            case .morocco:      return 24
            case .mexico:       return 9
            case .netherlands:  return 10
            case .poland:       return 26
            case .portugal:     return 8
            case .qatar:        return 51
            case .spain:        return 7
            case .senegal:      return 20
            case .serbia:       return 25
            case .saudiArabia:  return 49
            case .switzerland:  return 14
            case .tunisia:      return 35
            case .usa:          return 15
            case .uruguai:      return 13
            case .EUR:          return 999//"Gales/Scotland/Ukraine"
            case .PL1:          return 999//"Peru/Australia/United Arab Emirates 68"
            case .PL2:          return 999//"Costa Rica/New Zeland"
            case .wales:        return 18
            case .scotland:     return 39
            case .ukraine:      return 27
            case .peru:         return 22
            case .australia:    return 42
            case .arabEmirates: return 68
            case .costaRica:    return 31
            case .newZeland:    return 101
            }
        }
        
        var groupPosition: Int {
            switch self {
            case .qatar:        return 1
            case .ecuador:      return 2
            case .senegal:      return 3
            case .netherlands:  return 4
                
            case .england:      return 1
            case .iran:         return 2
            case .usa:          return 3
            case .EUR:          return 4
                
            case .argentina:    return 1
            case .saudiArabia:  return 2
            case .mexico:       return 3
            case .poland:       return 4
                
            case .france:       return 1
            case .PL1:          return 2
            case .denmark:      return 3
            case .tunisia:      return 4
                
            case .spain:        return 1
            case .PL2:          return 2
            case .germany:      return 3
            case .japan:        return 4

            case .belgium:      return 1
            case .canada:       return 2
            case .morocco:      return 3
            case .croatia:      return 4
                
            case .brazil:       return 1
            case .serbia:       return 2
            case .switzerland:  return 3
            case .cameroon:     return 4
                
            case .portugal:     return 1
            case .ghana:        return 2
            case .uruguai:      return 3
            case .korea:        return 4
                
            default:            return 99
            }
        }
        
        var groupID: Int {
            switch self {
            case .qatar:        return 1
            case .ecuador:      return 1
            case .senegal:      return 1
            case .netherlands:  return 1
                
            case .england:      return 2
            case .iran:         return 2
            case .usa:          return 2
            case .EUR:          return 2
                
            case .argentina:    return 3
            case .saudiArabia:  return 3
            case .mexico:       return 3
            case .poland:       return 3
                
            case .france:       return 4
            case .PL1:          return 4
            case .denmark:      return 4
            case .tunisia:      return 4
                
            case .spain:        return 5
            case .PL2:          return 5
            case .germany:      return 5
            case .japan:        return 5

            case .belgium:      return 6
            case .canada:       return 6
            case .morocco:      return 6
            case .croatia:      return 6
                
            case .brazil:       return 7
            case .serbia:       return 7
            case .switzerland:  return 7
            case .cameroon:     return 7
                
            case .portugal:     return 8
            case .ghana:        return 8
            case .uruguai:      return 8
            case .korea:        return 8
                
            default:            return 99
            }
        }
        
        var flag: String {
            switch self {
            case .argentina:    return "ar"
            case .belgium:      return "be"
            case .brazil:       return "br"
            case .canada:       return "ca"
            case .cameroon:     return "cm"
            case .croatia:      return "hr"
            case .denmark:      return "dk"
            case .ecuador:      return "ec"
            case .england:      return "gb-eng"
            case .france:       return "fr"
            case .germany:      return "de"
            case .ghana:        return "gh"
            case .iran:         return "ir"
            case .japan:        return "jp"
            case .korea:        return "kr"
            case .morocco:      return "ma"
            case .mexico:       return "mx"
            case .netherlands:  return "nl"
            case .poland:       return "pl"
            case .portugal:     return "pt"
            case .qatar:        return "qa"
            case .saudiArabia:  return "sa"
            case .spain:        return "es"
            case .senegal:      return "sn"
            case .serbia:       return "rs"
            case .switzerland:  return "ch"
            case .tunisia:      return "tn"
            case .usa:          return "us"
            case .uruguai:      return "uy"
            case .EUR:          return "tbd"
            case .PL1:          return "tbd"
            case .PL2:          return "tbd"
            case .wales:        return "gb-wls"
            case .scotland:     return "gb-sct"
            case .ukraine:      return "ua"
            case .peru:         return "pe"
            case .australia:    return "au"
            case .arabEmirates: return "ae"
            case .costaRica:    return "cr"
            case .newZeland:    return "nz"
            }
        }
        
    }
    
    enum EnumStadium: CaseIterable {
        case alBayt
        case khalifaInternational
        case alThumama
        case ahmadBinAli
        case lusail
        case stadium974
        case educationCity
        case alJanoub
        
        var name: String {
            switch self {
            case .alBayt:               return "Al Bayt Stadium"
            case .khalifaInternational: return "Khalifa International Stadium"
            case .alThumama:            return "Al Thumama Stadium"
            case .ahmadBinAli:          return "Ahmad Bin Ali Stadium"
            case .lusail:               return "Lusail Stadium"
            case .stadium974:           return "Stadium 974"
            case .educationCity:        return "Education City Stadium"
            case .alJanoub:             return "Al Janoub Stadium"
            }
        }
        
        var capacity: Int {
            switch self {
            case .alBayt:               return 60000
            case .khalifaInternational: return 45416
            case .alThumama:            return 40000
            case .ahmadBinAli:          return 40000
            case .lusail:               return 80000
            case .stadium974:           return 40000
            case .educationCity:        return 40000
            case .alJanoub:             return 40000
            }
        }
        
        var location: String {
            switch self {
            case .alBayt:               return "Al Khor"
            case .khalifaInternational: return "Doha"
            case .alThumama:            return "Doha"
            case .ahmadBinAli:          return "Al Rayyan"
            case .lusail:               return "Lusail"
            case .stadium974:           return "Doha"
            case .educationCity:        return "Al Rayyan"
            case .alJanoub:             return "Al Wakrah"
            }
        }
        
        var index: Int {
            switch self {
            case .alBayt:               return 1
            case .khalifaInternational: return 2
            case .alThumama:            return 3
            case .ahmadBinAli:          return 4
            case .lusail:               return 5
            case .stadium974:           return 6
            case .educationCity:        return 7
            case .alJanoub:             return 8
            }
        }
    }
    
    enum EnumGroups: CaseIterable {
        case a
        case b
        case c
        case d
        case e
        case f
        case g
        case h
        
        var name: String {
            switch self {
            case .a: return "A"
            case .b: return "B"
            case .c: return "C"
            case .d: return "D"
            case .e: return "E"
            case .f: return "F"
            case .g: return "G"
            case .h: return "H"
            }
        }
        
        var index: Int {
            switch self {
            case .a: return 1
            case .b: return 2
            case .c: return 3
            case .d: return 4
            case .e: return 5
            case .f: return 6
            case .g: return 7
            case .h: return 8
            }
        }
        
    }
    
}
