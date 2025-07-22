
import SwiftUI

enum MoodType: Int, CaseIterable {
    case party = 0
    case concert = 1
    case nightclub = 2
    case after = 3
    case before = 4
    case dinner = 5
    case bar = 6
    case street = 7
    case chepa = 8
    case other = 9
    
    func convertMoodTypeToInt() -> Int {
        switch self {
        case .party: return 0
        case .concert: return 1
        case .nightclub: return 2
        case .after: return 3
        case .before: return 4
        case .dinner: return 5
        case .bar: return 6
        case .street: return 7
        case .chepa: return 8
        case .other: return 9
        }
    }
    
    static func convertIntToMoodType(_ value: Int) -> MoodType {
        return MoodType(rawValue: value) ?? .other
    }

}

struct Mood {

    func data(for mood: MoodType) -> MoodView {
        switch mood {
        case .party:
            return MoodView(moodData: MoodData(icon: .iconMoodParty, title: "Appart"))
        case .concert:
            return MoodView(moodData: MoodData(icon: .iconMoodConcert, title: "Concert"))
        case .nightclub:
            return MoodView(moodData: MoodData(icon: .iconMoodNightClub, title: "Nightclub"))
        case .after:
            return MoodView(moodData: MoodData(icon: .iconMoodAfter, title: "After"))
        case .before:
            return MoodView(moodData: MoodData(icon: .iconMoodBefore, title: "Before"))
        case .dinner:
            return MoodView(moodData: MoodData(icon: .iconMoodDinner, title: "Diner"))
        case .bar:
            return MoodView(moodData: MoodData(icon: .iconMoodBar, title: "Bar"))
        case .street:
            return MoodView(moodData: MoodData(icon: .iconMoodStreet, title: "Street"))
        case .chepa:
            return MoodView(moodData: MoodData(icon: .iconChepa, title: "Chepa"))
        case .other:
            return MoodView(moodData: MoodData(icon: .iconMoodOther, title: "Autre"))
        }
    }
}
