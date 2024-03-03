import SwiftUI
import LonginusSwiftUI

struct RemoteIconCellView: View {

    let url: String?
    
    init(with url: String?) {
        self.url = url
    }
    
    var body: some View {
        
        VStack() {
            
            LGImage(source: URL(string: url ?? ""), placeholder: {
                        Image("destination_placeholder")
                            .font(.largeTitle) })
                    .onProgress(progress: { (data, expectedSize, _) in
                        //print("Downloaded: \(data?.count ?? 0)/\(expectedSize)")
                    })
                    .onCompletion(completion: { (image, data, error, cacheType) in
                        // Do nothing
                    })
                    .resizable()
                    .cancelOnDisappear(true)
                    .scaledToFit()
                    .cornerRadius(4)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray, lineWidth: 2))
                    .frame(alignment: .top)
            
            Spacer()
        }
        .padding(4)
    }

}

#Preview {
    RemoteIconCellView(with: "")
}
