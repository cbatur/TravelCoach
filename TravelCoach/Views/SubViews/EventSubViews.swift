
import SwiftUI

// This view is the Itinerary event list.
struct EventView: View {
    let day: Itinerary
    let city: String
    @State var venueName: IdentifiableString?
    @State var launchVenueDetail: Bool = false

    func isLink(_ activity: EventItem) -> Bool {
        if activity.categories.contains("checkin") || activity.categories.contains("checkout") {
            return false
        } else {
            return true
        }
    }
    
    func displayDailyDate(_ stringDate: String) -> String {
        // Create a date formatter for the input date format
        let inputFormatter = DateFormatter()
        // Specify the input format (adjust this according to your input string format)
        inputFormatter.dateFormat = "yyyy-MM-dd" // Change this based on the actual format of `stringDate`
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // This ensures the formatter doesn't depend on the device's locale

        // Convert the string to a Date object
        guard let date = inputFormatter.date(from: stringDate) else {
            return "Invalid date" // Return an error message or handle the error as needed
        }

        // Create a new formatter for the output date format
        let outputFormatter = DateFormatter()
        // Set the desired output format
        outputFormatter.dateFormat = "EEE, MMM d"
        outputFormatter.locale = Locale(identifier: "en_US") // Ensure output is in English

        // Convert the Date object to a string in the new format
        let formattedDate = outputFormatter.string(from: date)

        return formattedDate // Returns the date in "Mon, Mar 12" format
    }
    
    var body: some View {
        Section(header: Text(day.title)
                    .foregroundColor(.gray)
                    .font(.custom("Satoshi-Bold", size: 16))) {
                        
            Text("\(displayDailyDate(day.date))".uppercased())
                .foregroundColor(.wbPinkMediumAlt)
                .font(.custom("Satoshi-Bold", size: 16))
            
            ForEach(day.activities.sorted(by: { $0.index < $1.index }), id: \.self) { activity in
                Button {
                    self.venueName = IdentifiableString(value: "\(activity.title), \(self.city)")
                    DispatchQueue.main.async {
                        self.launchVenueDetail = self.venueName != nil
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: activity.categories.count > 0 ?
                              Icon(rawValue: activity.categories.first ?? "dot.square")?.system ?? "dot.square" :
                        "dot.square")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .frame(alignment: .center)
                        
                        Button {
                            self.venueName = IdentifiableString(value: "\(activity.title), \(self.city)")
                            DispatchQueue.main.async {
                                self.launchVenueDetail = self.venueName != nil
                            }
                        } label: {
                            Text("\(activity.title)")
                                .foregroundColor(.black.opacity(0.6))
                                .fontWeight(isLink(activity) ? .bold : .regular)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .sheet(item: $venueName) { item in
            VenueDetailsView(item.value)
        }
    }
}
