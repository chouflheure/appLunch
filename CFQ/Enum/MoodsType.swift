
import SwiftUI

enum MoodType: CaseIterable {
    case party
    case concert
    case nightclub
    case after
    case before
    case dinner
    case bar
    case street
    case other
}

struct Mood {

    func data(for mood: MoodType) -> MoodView {
        switch mood {
        case .party:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodParty), title: "Party"))
        case .concert:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodConcert), title: "Concert"))
        case .nightclub:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodNightClub), title: "Nightclub"))
        case .after:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodAfter), title: "After"))
        case .before:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodBefore), title: "Before"))
        case .dinner:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodDinner), title: "Diner"))
        case .bar:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodBar), title: "Bar"))
        case .street:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodStreet), title: "Street"))
        case .other:
            return MoodView(moodData: MoodData(icon: UIImage(resource: .iconMoodOther), title: "Other"))
        }
    }
}
