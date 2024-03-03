import Popovers
import SwiftUI
import Combine

class AutocompleteViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var suggestions: [String] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let apiKey = "AIzaSyDgMjCGzr5jeGgsNtq3XRmFunlpmSGIT9Y"
    
    init() {
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (queryString) -> AnyPublisher<[String], Never> in
                if queryString.count < 3 {
                    return Just([]).eraseToAnyPublisher()
                }
                return self.fetchAutocomplete(queryString)
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
            .assign(to: &$suggestions)
    }
    
    private func fetchAutocomplete(_ query: String) -> AnyPublisher<[String], Error> {
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(query)&types=(cities)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GooglePlacesResponse.self, decoder: JSONDecoder())
            .map { response in
                response.predictions.map { $0.description }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func selectSuggestion(_ suggestion: String) {
        self.query = suggestion
        self.suggestions = []
    }
    
    func resetSearch() {
        self.query = ""
        self.suggestions = []
    }
}

// Model for Google Places response
struct GooglePlacesResponse: Codable {
    let predictions: [Prediction]
    
    struct Prediction: Codable {
        let description: String
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AutocompleteViewModel()

    @State var isPresented = false
    @State private var searchCity = ""
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    let dateFormatter = DateFormatter()
    @State private var proceedToIniterary = false
    @State private var isMock = false
    @FocusState private var isInputActive: Bool

    init () {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    private func clearText() {
        searchCity = ""
        viewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func chooseMonth(numberMonths: Int) -> Date {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.month = numberMonths
        return Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
    }
    
    func processDates(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var body: some View {
        NavigationStack { 
            ScrollView {
                VStack {
                    HStack {
                        Text("TRAVEL")
                            .foregroundColor(.accentColor.opacity(0.8))
                            .font(.largeTitle)
                            .fontWeight(.medium) +
                        Text("COACH ")
                            .font(.largeTitle).bold()
                            .foregroundColor(.gray)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                    .padding()
                    
                    HStack {
                        TextField("Where to?", text: $viewModel.query)
                        .focused($isInputActive)
                        .font(.headline)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(24)
                        .overlay(
                            HStack {
                                Spacer()
                                if !searchCity.isEmpty || !viewModel.query.isEmpty {
                                    Button(action: clearText) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .font(.largeTitle)
                                    }
                                    .padding(.trailing, 10)
                                }
                                
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        //showNewUserModal = true
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(Color.blue).opacity(0.6)
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: "plus")
                                            .font(.system(size: 18)).bold()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.white)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        )
                    }
                    .padding()
                    Spacer()

                    LazyVStack {
                        VStack {
                            ForEach(viewModel.suggestions, id: \.self) { suggestion in
                                HStack {
                                    Image(suggestion.split(separator: ",").map(String.init).last?.replacingOccurrences(of: " ", with: "") ?? "")
                                        .resizable()
                                        .frame(width: 26, height: 18)
                                    
                                    Text(suggestion)
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                                }
                                .onTapGesture {
                                    self.searchCity = suggestion
                                    isInputActive = false
                                    viewModel.selectSuggestion(suggestion)
                                }
                                Divider()
                            }
                        }
                        .frame(height: isInputActive == false || viewModel.suggestions.count == 0 || viewModel.query.isEmpty ? 0 : 85)
                        .padding()
                        .isHidden(isInputActive == false)
                        
                        TabView {
                            ForEach(0..<5) { i in
                                VStack {
                                    CalendarMonthView(
                                        dates: processDates,
                                        items: CalendarMethods().createCalendarItems(
                                            month: self.chooseMonth(numberMonths: i * 1).month,
                                            year: self.chooseMonth(numberMonths: i * 1).year
                                        )
                                    )
                                }
                                .padding(.bottom, 30)
                                .padding()
                            }
                        }
                        .isHidden(isInputActive && viewModel.suggestions.count > 0)
                        .frame(width: UIScreen.main.bounds.width, height: 360)
                        .tabViewStyle(PageTabViewStyle())
                        .onAppear {
                            UIPageControl.appearance().currentPageIndicatorTintColor = .black
                            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                        }
                    }
                    .padding()
                }
            }

            HStack {
                Button {
                    isPresented = true
                } label: {
                    VisitCell(
                        visit: Visit(
                            locationName: self.searchCity,
                            tagColor: .orange,
                            arrivalDate: self.startDate ?? Date(),
                            departureDate: self.endDate ?? Date()
                        )
                    )
                }
                Spacer()
                
                VStack {
                    Button(action: {
                        isMock = false
                        proceedToIniterary = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill") // Icon
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("Continue")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.mint)
                        .cornerRadius(10)
                    }
                    Divider()
                    Button(action: {
                        isMock = true
                        proceedToIniterary = true
                    }) {
                        Text("Mock City")
                            .font(.caption)
                    }
                }
            }
            .navigationDestination(isPresented: $proceedToIniterary) {
                DailyPlanView(city: self.searchCity, isMock: isMock)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .center)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

struct Visit {
    let locationName: String
    let tagColor: Color
    let arrivalDate: Date
    let departureDate: Date

    var duration: String {
        arrivalDate.travelDate + " ➝ " + departureDate.travelDate
    }
}

extension Visit: Identifiable {
    var id: Int {
        UUID().hashValue
    }

}

struct VisitCell: View {
    
    let visit: Visit

    var body: some View {
        HStack {
            tagView

            VStack(alignment: .leading) {
                locationName
                visitDuration
            }

            Spacer()
        }
        .frame(height: VisitPreviewConstants.cellHeight)
        .padding(.vertical, VisitPreviewConstants.cellPadding)
    }

}

private extension VisitCell {

    var tagView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.orange)
            .frame(width: 5, height: 30)
    }

    var locationName: some View {
        Text(visit.locationName)
            .font(.system(size: 20))
            .lineLimit(1)
    }

    var visitDuration: some View {
        Text(visit.duration)
            .font(.system(size: 14))
            .lineLimit(1)
    }

}

struct VisitPreviewConstants {
    static let cellHeight: CGFloat = 30
    static let cellPadding: CGFloat = 10
    static let previewTime: TimeInterval = 3
}

extension Visit {

    static func mock(withDate date: Date) -> Visit {
        Visit(locationName: "Dublin, Ireland",
              tagColor: .randomColor,
              arrivalDate: date,
              departureDate: date.addingTimeInterval(60*60))
    }
}
