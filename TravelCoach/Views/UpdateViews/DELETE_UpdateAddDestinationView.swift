
import SwiftUI
import SwiftData

struct UpdateAddDestinationView: View {
    @StateObject var chatAPIViewModel: ChatAPIViewModel = ChatAPIViewModel()
    @StateObject private var viewModel = AutocompleteViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    @State private var showAlert = false

    @Bindable var destination: Destination
    @FocusState private var isInputActive: Bool
    @State private var searchCity = ""
    
    init(destination: Destination) {
        _destination = Bindable(wrappedValue: destination)
    }
    
    func reloadIcon() {
        self.placesViewModel.searchLocation(with: destination.name.searchSanitized() + "+city")
    }
    
    func handlePlaceImageChanged() {
        DispatchQueue.main.async { [self] in
            guard let icon = self.placesViewModel.places.randomElement()?.icon else { return }
            self.chatAPIViewModel.downloadImage(from: icon)
        }
    }
    
    private var alertMessage: String {
        let baseMessage = "Set your destination as \(self.searchCity)? "
        if destination.itinerary.count > 0 {
            return baseMessage + "\n\nDestination city will change. Your old initerary will be deleted and a new one will be generated."
        } else {
            return baseMessage
        }
    }
    
    func setToNewCity() {
        destination.name = self.searchCity
        destination.itinerary = []
        self.reloadIcon()
    }
    
    var body: some View {
        ScrollView {
            //LoadingView(message: .constant(self.chatAPIViewModel.loadingIconMessage)) {
                VStack {
                    VStack {
                        HStack {
                            Image(destination.name.split(separator: ",").map(String.init).last?.replacingOccurrences(of: " ", with: "") ?? "")
                                .resizable()
                                .frame(width: 26, height: 18)
                            
                            Text(destination.name.split(separator: ",").map(String.init).first ?? "")
                                .font(.custom("Satoshi-Regular", size: 25))
                                .foregroundColor(.white) +
                            Text(destination.name.split(separator: ",").map(String.init).last ?? "")
                                .font(.custom("Satoshi-Bold", size: 25))
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .cardStyle(.black.opacity(0.6))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                    }
                    .padding()
                    .background(
                        DestinationIconView(iconData: destination.icon)
                    )
                    .cardStyle()
                    
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
                            }
                        )
                        .padding(7)
                    
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
                                showAlert = true
                                isInputActive = false
                                viewModel.selectSuggestion(suggestion)
                            }
                            Divider()
                        }
                    }
                    .frame(height: isInputActive == false || viewModel.suggestions.count == 0 || viewModel.query.isEmpty ? 0 : 120)
                    .padding()
                    .isHidden(isInputActive == false)
                }
                .alert(isPresented: $showAlert) { // Use the $ prefix to bind showAlert
                    Alert(
                        title: Text("\(self.searchCity)"),
                        message: Text(alertMessage),
                        primaryButton: .destructive(Text("OK")) {
                            self.setToNewCity()
                        },
                        secondaryButton: .cancel() {
                            // Action for Cancel button
                            print("Cancel pressed")
                        }
                    )
                }
                .onChange(of: chatAPIViewModel.imageData) { oldData, newData in
                    destination.icon = newData
                }
                .navigationBarTitle("", displayMode: .inline)
            //}
        }
    }
    
    private func clearText() {
        searchCity = ""
        viewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func parseDateRange() -> String {
        let dateRange = "\(destination.startDate.formatted(date: .long, time: .omitted)) and \(destination.endDate.formatted(date: .long, time: .omitted))"
        return dateRange
    }
    
}
