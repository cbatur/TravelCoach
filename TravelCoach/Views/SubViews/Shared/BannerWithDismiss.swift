
import SwiftUI

struct BannerWithDismiss: View {
    var dismiss: () -> Void
    var headline: String? = nil
    var subHeadline: String? = nil

    var body: some View {
        VStack {
            Button(action: {
                dismiss()
            }) {
                VStack {
                    Text(headline ?? "")
                        .font(.custom("Gilroy-Bold", size: 24))
                        .foregroundColor(Color.wbPinkMediumAlt)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .isHidden(headline == nil)
                    
                    Text(subHeadline ?? "")
                        .font(.custom("Gilroy-Regular", size: 20))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                        .isHidden(subHeadline == nil)
                }
                .padding(.top, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

