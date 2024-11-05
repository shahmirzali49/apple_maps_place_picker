import SwiftUI

struct AddressView: View {
    let place: Place?
    let config: AddressViewConfig
    let onConfirm: (Place) -> Void
    
    var body: some View {
        if let place = place {
            VStack(spacing: 16) {
               
                Text(place.address ?? config.unkownAddressText)
                    .font(.system(size: config.addressTextStyle.fontSize,
                                weight: config.addressTextStyle.fontWeight))
                    .foregroundColor(config.addressTextStyle.foregroundColor)
                    .lineLimit(2)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    onConfirm(place)
                }) {
                    Text(config.confirmButtonText)
                        .font(.system(size: config.confirmButtonStyle.textStyle.fontSize,
                                      weight: config.confirmButtonStyle.textStyle.fontWeight))
                        .foregroundColor(config.confirmButtonStyle.textStyle.foregroundColor)
                        .padding(config.confirmButtonStyle.padding)
                        .frame(maxWidth: .infinity)
                        .background(config.confirmButtonStyle.backgroundColor)
                        .cornerRadius(config.confirmButtonStyle.cornerRadius)
                }
            }
            .padding(config.addressPadding)
            .padding(.bottom, (UIApplication.shared.connectedScenes
                                .first { $0 is UIWindowScene }
                                .flatMap { $0 as? UIWindowScene }?
                                .windows
                                .first { $0.isKeyWindow }?
                                .safeAreaInsets.bottom) ?? 0)
            .background(config.backgroundColor)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .shadow(color: .gray.opacity(0.2),
                    radius: 5,
                    x: 0,
                    y: -5)
//            .shadow(radius: 5)

        } else {
            Text(config.notFoundAddressText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .padding()
        }
    }
}
