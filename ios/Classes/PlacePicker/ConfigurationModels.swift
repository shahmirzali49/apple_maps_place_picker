import SwiftUI


struct SearchBarConfig {
    var hintText: String
    var leadingIconColor: Color
    var textFieldTextStyle: TextStyle
    var textFieldBackgroundColor: Color
    var padding: EdgeInsets
    var backgroundColor: Color
    var cancelButtonText: String
    var cancelButtonTextColor: Color
    
    init(from dict: [String: Any]?) {
        // Hint Text
        self.hintText = dict?["hintText"] as? String ?? "Search location"
        
        if let leadingColorValue = dict?["leadingIconColor"] as? Int {
            self.leadingIconColor = Color(UIColor(rgb: leadingColorValue))
        } else {
            self.leadingIconColor = Color(.gray)
        }
        
        // Text Field Style
        if let textStyleDict = dict?["textFieldTextStyle"] as? [String: Any] {
            
            self.textFieldTextStyle = TextStyle(from: textStyleDict)
        } else {
            self.textFieldTextStyle = TextStyle()
        }
        
        // Text Field Background Color
        if let bgColorValue = dict?["textFieldBackgroundColor"] as? Int {
            self.textFieldBackgroundColor = Color(UIColor(rgb: bgColorValue))
        } else {
            self.textFieldBackgroundColor = Color(.systemGray6)
        }
        
        // Padding
        if let paddingDict = dict?["padding"] as? [String: Any] {
            self.padding = EdgeInsets(
                top: paddingDict["top"] as? CGFloat ?? 10,
                leading: paddingDict["left"] as? CGFloat ?? 10,
                bottom: paddingDict["bottom"] as? CGFloat ?? 10,
                trailing: paddingDict["right"] as? CGFloat ?? 10
            )
        } else {
            self.padding = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        }
        
        // Background Color
        if let bgColorValue = dict?["backgroundColor"] as? Int {
            self.backgroundColor = Color(UIColor(rgb: bgColorValue))
        } else {
            self.backgroundColor = Color(.systemBackground)
        }
        
        // Cancel Button Text and Color
        self.cancelButtonText = dict?["cancelButtonText"] as? String ?? "Cancel"
        
        if let cancelColorValue = dict?["cancelButtonTextColor"] as? Int {
            self.cancelButtonTextColor = Color(UIColor(rgb: cancelColorValue))
        } else {
            self.cancelButtonTextColor = Color.blue
        }
    }
}

struct AddressViewConfig {
    var addressPadding: EdgeInsets
    var backgroundColor: Color
    var addressTextStyle: TextStyle
    var confirmButtonStyle: ButtonStyle
    var confirmButtonText: String
    var unkownAddressText: String
    var notFoundAddressText: String
    
    init(from dict: [String: Any]?) {
        if let paddingDict = dict?["addressPadding"] as? [String: CGFloat] {
            self.addressPadding = EdgeInsets(
                top: paddingDict["top"] ?? 6,
                leading: paddingDict["left"] ?? 10,
                bottom: paddingDict["bottom"] ?? 6,
                trailing: paddingDict["right"] ?? 10
            )
        } else {
            self.addressPadding = EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
        }
        
        // Background Color
        if let bgColorValue = dict?["backgroundColor"] as? Int {
            self.backgroundColor = Color(UIColor(rgb: bgColorValue))
        } else {
            self.backgroundColor = Color(.systemBackground)
        }
        
        if let styleDict = dict?["addressTextStyle"] as? [String: Any] {
            self.addressTextStyle = TextStyle(from: styleDict)
        } else {
            self.addressTextStyle = TextStyle()
        }
        
        
        self.confirmButtonStyle = ButtonStyle(from: dict?["confirmButtonStyle"] as? [String: Any])
        self.confirmButtonText = dict?["confirmButtonText"] as? String ?? "Confirm Location"
        self.unkownAddressText = dict?["unkownAddressText"] as? String ?? "Unkown Address"
        self.notFoundAddressText = dict?["notFoundAddressText"] as? String ?? "Not Found Address"

    }
}

struct CenterMarkerConfig {
    var markerColor: Color
    var markerSize: CGFloat
    var markerBuilder: (() -> AnyView)?
    
    init(from dict: [String: Any]?) {
        if let colorValue = dict?["markerColor"] as? Int {
            self.markerColor = Color(UIColor(rgb: colorValue))
        } else {
            self.markerColor = .red
        }
        
        self.markerSize = dict?["markerSize"] as? CGFloat ?? 30
        self.markerBuilder = dict?["markerBuilder"] as? (() -> AnyView)
    }
}

struct SearchResultConfig {
    var itemTextStyle: TextStyle
    var itemPadding: EdgeInsets
    var itemMargin: EdgeInsets
    var itemBackgroundColor: Color
    var backgroundColor: Color
    
    
    init(from dict: [String: Any]?) {
        if let styleDict = dict?["itemTextStyle"] as? [String: Any] {
            self.itemTextStyle = TextStyle(from: styleDict)
        } else {
            self.itemTextStyle = TextStyle()
        }
        
        if let paddingDict = dict?["itemPadding"] as? [String: CGFloat] {
//            print("paddingDict \(paddingDict)")
            self.itemPadding = EdgeInsets(
                top: paddingDict["top"] ?? 0,
                leading: paddingDict["left"] ?? 0,
                bottom: paddingDict["bottom"] ?? 0,
                trailing: paddingDict["right"] ?? 0
            )
        } else {
            self.itemPadding = EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8)
        }

        if let marginDict = dict?["itemMargin"] as? [String: Any] {
            // print("itemMargin \(marginDict)")
            self.itemMargin = EdgeInsets(
                top: marginDict["top"] as? CGFloat ?? 0,
                leading: marginDict["left"] as? CGFloat ?? 0,
                bottom: marginDict["bottom"] as? CGFloat ?? 0,
                trailing: marginDict["right"] as? CGFloat ?? 0
            )

        } else {
            self.itemMargin = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        }
        
        if let bgColorValue = dict?["backgroundColor"] as? Int {
            self.backgroundColor = Color(UIColor(rgb: bgColorValue))
        } else {
            self.backgroundColor = Color(.systemBackground)
        }
        
        if let itemBgColorValue = dict?["itemBackgroundColor"] as? Int {
            self.itemBackgroundColor = Color(UIColor(rgb: itemBgColorValue))
        } else {
            self.itemBackgroundColor = Color(.systemBackground)
        }
    }
}

struct TextStyle {
    var fontSize: CGFloat
    var fontWeight: Font.Weight
    var foregroundColor: Color
    
    init(from dict: [String: Any]? = nil) {
        self.fontSize = dict?["fontSize"] as? CGFloat ?? 16
        self.fontWeight = Font.Weight(from: dict?["fontWeight"] as? String ?? "regular")
        
        if let colorValue = dict?["foregroundColor"] as? Int {
            self.foregroundColor = Color(UIColor(rgb: colorValue))
        } else {
            self.foregroundColor = .primary
        }
    }
}

struct ButtonStyle {
    var backgroundColor: Color
    var cornerRadius: CGFloat
    var textStyle: TextStyle
    var padding: EdgeInsets
    
    init(from dict: [String: Any]?) {
        if let colorValue = dict?["backgroundColor"] as? Int {
            self.backgroundColor = Color(UIColor(rgb: colorValue))
        } else {
            self.backgroundColor = .blue
        }
        
        self.cornerRadius = dict?["cornerRadius"] as? CGFloat ?? 10
        
        if let textSyleDict = dict?["textStyle"] as? [String: Any] {
            self.textStyle = TextStyle(from: textSyleDict)
        } else {
            self.textStyle = TextStyle()
            self.textStyle.foregroundColor = .white
        }
        
        if let paddingDict = dict?["padding"] as? [String: CGFloat] {
            self.padding = EdgeInsets(
                top: paddingDict["top"] ?? 0,
                leading: paddingDict["left"] ?? 0,
                bottom: paddingDict["bottom"] ?? 0,
                trailing: paddingDict["right"] ?? 0
            )
        } else {
            self.padding = EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        }
    }
}

// Helper extensions
extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}

extension Font.Weight {
    init(from string: String) {
        switch string {
        case "FontWeight.w700": self = .bold
        case "FontWeight.w600": self = .semibold
        case "FontWeight.w500": self = .medium
        case "FontWeight.w300": self = .light
        default: self = .regular
        }
    }
}
