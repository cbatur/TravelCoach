import SwiftUI

struct AddDestinationButton: View {
    var body: some View {
        HStack {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding()
                .background(Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30))
                .padding(.leading)
            
            Spacer()
            
            Text("Add New Destination".uppercased())
                .font(.custom("Bevellier-Regular", size: 26))
                .foregroundColor(.black.opacity(0.8))
            
            Spacer()

            Image(systemName: "plus")
                .foregroundColor(.clear)
                .padding()
                .background(Circle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30))
                .padding(.trailing)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding()
    }
}
