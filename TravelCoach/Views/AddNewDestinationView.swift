
import SwiftUI

struct AddNewDestinationView: View {
    @StateObject private var viewModel = GooglePlacesViewModel()
    @StateObject var placesViewModel: PlacesViewModel = PlacesViewModel()
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var onDataReceive: ((String,String)) -> Void

    @FocusState private var isInputActive: Bool
    @State private var searchCity = ""
    
    private var alertMessage: String {
        return "Set your destination as \(self.searchCity)? "
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    CityTitleBannerView(cityName: "Add New, Destination")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                }
                .padding()
                .background(
                    Image("destination_placeholder")
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
                            Image(suggestion.description.split(separator: ",").map(String.init).last?.replacingOccurrences(of: " ", with: "") ?? "")
                                .resizable()
                                .frame(width: 26, height: 18)
                            
                            Text(suggestion.description)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, alignment: .leading)
                        }
                        .onTapGesture {
                            self.searchCity = suggestion.description
                            onDataReceive((suggestion.description, suggestion.place_id))
                            showAlert = true
                            isInputActive = false
                            viewModel.selectSuggestion(suggestion.description)
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
                        //self.setToNewCity()
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel() {
                        print("Cancel pressed")
                    }
                )
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    
    private func clearText() {
        searchCity = ""
        viewModel.resetSearch()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
