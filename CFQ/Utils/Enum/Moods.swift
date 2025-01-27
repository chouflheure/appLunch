
import SwiftUI

enum MoodType: String, CaseIterable {
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

    func data(for mood: MoodType) -> MoodData {
        switch mood {
        case .party:
            return MoodData(icon: UIImage(resource: .iconMoodParty), title: "Party")
        case .concert:
            return MoodData(icon: UIImage(resource: .iconMoodConcert), title: "Concert")
        case .nightclub:
            return MoodData(icon: UIImage(resource: .iconMoodNightClub), title: "Nightclub")
        case .after:
            return MoodData(icon: UIImage(resource: .iconMoodAfter), title: "After")
        case .before:
            return MoodData(icon: UIImage(resource: .iconMoodBefore), title: "Before")
        case .dinner:
            return MoodData(icon: UIImage(resource: .iconMoodDinner), title: "Diner")
        case .bar:
            return MoodData(icon: UIImage(resource: .iconMoodBar), title: "Bar")
        case .street:
            return MoodData(icon: UIImage(resource: .iconMoodStreet), title: "Street")
        case .other:
            return MoodData(icon: UIImage(resource: .iconMoodOther), title: "Other")
        }
    }
}

struct MoodData: View {
    let icon: UIImage
    let title: String

    var body: some View {
        HStack {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 20))
        }
    }
}

struct MoodDataTemplate: View {
    let icon: UIImage = .iconMoodBefore
    let title: String = "Mood"
    
    var body: some View {
        HStack {
            Image(uiImage: icon)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.gray)
            Text(title)
                .foregroundColor(.gray)
                .font(.system(size: 20))
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        MoodDataTemplate()
    }
}
