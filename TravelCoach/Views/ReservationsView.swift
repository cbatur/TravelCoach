
import SwiftUI

struct ReservationsView: View {
//    let travelData: [TravelSection] = [
//        TravelSection(title: "FRIDAY, DECEMBER 1, 2023", items: [
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: ""),
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: ""),
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: "")
//        ]),
//        TravelSection(title: "FRIDAY, DECEMBER 1, 2023", items: [
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: "")
//        ]),
//        TravelSection(title: "FRIDAY, DECEMBER 1, 2023", items: [
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: "")
//        ]),
//        TravelSection(title: "FRIDAY, DECEMBER 1, 2023", items: [
//            TravelItem(iconName: "airplane.departure", title: "YYZ - WAW", subtitle: "LO 46 (LOT - Polish Airlines)"),
//            TravelItem(iconName: "clock", title: "6 hrs 55 mins layover in WAW", subtitle: "")
//        ])
//    ]
    
    
    
    var travelData: [TravelSection] = []

    init(_ travelData: [TravelSection]) {
        self.travelData = travelData
    }
    
    var body: some View {
        NavigationView {
            VStack {

                
                List {
                    ForEach(travelData) { section in
                        Section(header: Text(section.title)) {
                            ForEach(section.items) { item in
                                HStack {
                                    VStack {
                                        Text(item.scheduledTime)
                                            .fontWeight(.semibold)
                                    }
                                    Image(systemName: item.iconName)
                                    VStack(alignment: .leading) {
                                        Text(item.title.uppercased())
                                            .fontWeight(.semibold)
                                        Text(item.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TravelSection: Identifiable {
    let id: UUID = UUID()
    let title: String
    let items: [TravelItem]
}

struct TravelItem: Identifiable {
    let id: UUID = UUID()
    let iconName: String
    let title: String
    let subtitle: String
    let scheduledTime: String
}
