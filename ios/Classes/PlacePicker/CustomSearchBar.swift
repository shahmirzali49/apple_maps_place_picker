
import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    @Binding var isPresented: Bool
    @Binding var shouldPerformSearch: Bool
    var isFocused: FocusState<Bool>.Binding
    let config: SearchBarConfig
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(config.leadingIconColor)
                    .padding(.leading)
                
                    TextField(config.hintText, text: $text)
                         .focused(isFocused)
                         .submitLabel(.done)
                         .onTapGesture {
                             shouldPerformSearch = true
                             withAnimation {
                                 isFocused.wrappedValue = true
                                 isPresented = true
                                }
                         }
                         .onSubmit {
                             shouldPerformSearch = false
                             if text.isEmpty {
                                 isPresented = false
                             }
                         }
                        .font(.system(size: config.textFieldTextStyle.fontSize, weight: config.textFieldTextStyle.fontWeight))
                        .foregroundColor(config.textFieldTextStyle.foregroundColor)
                        .padding(8)   
            }
            .background(config.textFieldBackgroundColor)
            .cornerRadius(8)
            
            if isPresented {
                Button(config.cancelButtonText) {
                    text = ""
                    withAnimation {
                        isPresented = false
                        isFocused.wrappedValue = false
                    }
                    
                }
                .padding(.leading, 8)
                .foregroundColor(config.cancelButtonTextColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(config.padding)
        .background(config.backgroundColor)
    }
}
