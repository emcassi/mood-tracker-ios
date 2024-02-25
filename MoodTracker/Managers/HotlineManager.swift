//
//  HotlineManager.swift
//  MoodTracker
//
//  Created by Alex Wayne on 2/24/24.
//

import Foundation
import UIKit
import SQLite

struct HotlineCountry {
    let id: String
    let name: String
    let emoji: String
}

enum HotlineType {
    case General
    case Lgbtq
    case Veterans
    case Trans
    case Womens
    case Youth
}

struct Hotline {
    let id: Int
    let name: String
    let description: String
    let phone: String
    let website: String
    let country: HotlineCountry
    let type: HotlineType
}

class HotlineManager {
    
    static func getCountries() -> [HotlineCountry] {
        var countries: [HotlineCountry] = []
        
        
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentsURL.appendingPathComponent("mudi.sqlite").path

            if !fileManager.fileExists(atPath: dbPath) {
                let bundlePath = Bundle.main.path(forResource: "mudi", ofType: "sqlite")!
                try fileManager.copyItem(atPath: bundlePath, toPath: dbPath)
            }

            let db = try Connection(dbPath)
            
            let hotlines = Table("countries")
            let id = Expression<String?>("id")
            let country = Expression<String?>("name")
            let emoji = Expression<String?>("emoji")
            
            
            for hotline in try db.prepare(hotlines).sorted(by: { try $0.get(country)! < $1.get(country)!}) {
                guard let countryId = hotline[id] else { continue }
                guard let countryName = hotline[country] else { continue }
                guard let countryEmoji = hotline[emoji] else { continue }
                
                let newCountry = HotlineCountry(id: countryId, name: countryName, emoji: countryEmoji)
                countries.append(newCountry)
            }
        } catch {
            print (error)
            return []
        }
        return countries
    }
    
    static func searchCountries(term: String) -> [HotlineCountry] {
        var countries: [HotlineCountry] = []
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentsURL.appendingPathComponent("mudi.sqlite").path

            if !fileManager.fileExists(atPath: dbPath) {
                let bundlePath = Bundle.main.path(forResource: "mudi", ofType: "sqlite")!
                try fileManager.copyItem(atPath: bundlePath, toPath: dbPath)
            }

            let db = try Connection(dbPath)
            let hotlines = Table("countries")
            let id = Expression<String?>("id")
            let country = Expression<String?>("name")
            let emoji = Expression<String?>("emoji")
            
            
            for hotline in try db.prepare(hotlines).filter({ try $0.get(country)!.lowercased().contains(term.lowercased()) }).sorted(by: { try $0.get(country)! < $1.get(country)!}) {
                guard let countryId = hotline[id] else { continue }
                guard let countryName = hotline[country] else { continue }
                guard let countryEmoji = hotline[emoji] else { continue }
                
                let newCountry = HotlineCountry(id: countryId, name: countryName, emoji: countryEmoji)
                countries.append(newCountry)
            }
        } catch {
            print (error)
            return []
        }
        return countries
    }
}
