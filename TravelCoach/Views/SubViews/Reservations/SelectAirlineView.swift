
import SwiftUI
import Foundation
import Combine

struct SelectAirlineView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var flightManageViewModel = FlightManageViewModel()
    @State private var airlineCode: String = ""
    @FocusState private var isInputActive: Bool

    private func clearText() {
        airlineCode = ""
        flightManageViewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        VStack {
            TextField("Airline", text: $flightManageViewModel.searchText)
                .focused($isInputActive)
                .font(.headline)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        if !airlineCode.isEmpty || !flightManageViewModel.filteredAirlines.isEmpty {
                            Button(action: clearText) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                            .padding(.trailing, 10)
                        }
                    }
                )
                .padding(7)
                .opacity(flightManageViewModel.isLoaded ? 1.0 : 0.1)
                .background(flightManageViewModel.isLoaded ? .orange : .pink)
                //.disabled(!flightManageViewModel.isLoaded)
            
            
            VStack {
                List(flightManageViewModel.filteredAirlines, id: \.id) { airline in
                    HStack {
                        Text(airline.airlineCode)
                            .font(.headline)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
//                                self.airlineCode = airline.airlineCode
//                                isInputActive = false
//                                flightManageViewModel.selectAirline(airline.airlineCode)
                            }
                        
                        Text(airline.name)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                            
                    }
                    Divider()
                }
            }
//            .onAppear {
//                self.flightManageViewModel.loadAirlines()
//            }
//            .frame(height: isInputActive == false || flightManageViewModel.airlines.count == 0 || flightManageViewModel.filteredAirlines.isEmpty ? 0 : 120)
//            .padding()
//            .isHidden(isInputActive == false)
            
            
        }
        
    }
}

class FlightManageViewModel: ObservableObject {
    @Published var airlines: [AirlineBasic] = []
    @Published var filteredAirlines: [AirlineBasic] = []
    @Published var searchText = ""
    @Published var isLoaded: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadAirlines()
        setupSearch()
    }

    func loadAirlines() {
        guard let url = Bundle.main.url(forResource: "AirlineCodes", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }

        let decoder = JSONDecoder()
        if let decodedAirlines = try? decoder.decode([AirlineBasic].self, from: data) {
            self.airlines = decodedAirlines
            isLoaded = true
        }
    }

    func setupSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                if !searchText.isEmpty {
                    self?.filterAirlines(searchText: searchText)
                }
            }
            .store(in: &cancellables)
    }

    func filterAirlines(searchText: String) {
        filteredAirlines = airlines.filter { airline in
            airline.name.lowercased().contains(searchText.lowercased()) ||
            airline.airlineCode.lowercased().contains(searchText.lowercased())
        }
    }
    
    func resetSearch() {
        searchText = ""
        filteredAirlines = []
    }
    
    func selectAirline(_ airlineCode: String) {
        self.searchText = airlineCode
        self.filteredAirlines = []
    }
}
