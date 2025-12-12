import Foundation
import UIKit

public enum DateStyle {
    ///Times should be shown in the 12 hour format
    case twelveHour
    
    ///Times should be shown in the 24 hour format
    case twentyFourHour
    
    ///Times should be shown according to the user's system preference.
    case system
}

public struct CalendarStyle {
    public var header = DayHeaderStyle()
    public var timeline = TimelineStyle()
    public var backgroundColor = SystemColors.systemBackground  // Background color for the whole calendar
    public var cornerRadius: CGFloat = 0  // Corner radius for the whole calendar
    public init() {}
}

public struct DayHeaderStyle {
    public var daySymbols = DaySymbolsStyle()
    public var daySelector = DaySelectorStyle()
    public var swipeLabel = SwipeLabelStyle()
    public var backgroundColor = SystemColors.systemBackground
    public var separatorColor = SystemColors.systemSeparator
    public var separatorHidden: Bool = false  // Set to true to hide the separator line below the header
    public var topSpacing: CGFloat = 0

    // Navigation button icons
    public var previousWeekIcon: UIImage? = {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .thin, scale: .small)
            return UIImage(systemName: "arrow.left", withConfiguration: config)
        } else {
            return nil
        }
    }()
    public var nextWeekIcon: UIImage? = {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .thin, scale: .small)
            return UIImage(systemName: "arrow.right", withConfiguration: config)
        } else {
            return nil
        }
    }()
    public var navigationButtonColor = UIColor.black
    public var navigationButtonLeadingSpacing: CGFloat = 24
    public var navigationButtonTrailingSpacing: CGFloat = 24

    public init() {}
}

public struct DaySelectorStyle {
    public var activeTextColor = UIColor.white
    public var selectedBackgroundColor = SystemColors.label

    public var weekendTextColor = SystemColors.secondaryLabel
    public var inactiveTextColor = SystemColors.label
    public var inactiveBackgroundColor = UIColor.clear

    public var todayInactiveTextColor = SystemColors.label
    public var todayActiveTextColor = UIColor.white
    public var todayActiveBackgroundColor = SystemColors.label

    public var font = UIFont.systemFont(ofSize: 16, weight: .regular)
    public var todayFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    public var dayNameFont = UIFont.systemFont(ofSize: 12, weight: .regular)

    // Day name colors (Mon-Sun)
    public var dayNameSelectedColor = UIColor.black
    public var dayNameUnselectedColor = UIColor.gray

    // Date number colors (1-31)
    public var dateNumberSelectedColor = UIColor.black
    public var dateNumberUnselectedColor = SystemColors.label
    public var dateNumberCurrentDayColor: UIColor? = nil  // Text color for current day (e.g., Nov 19). If nil, uses selected/unselected colors

    // Circle background color for date numbers
    public var dateCircleBackgroundSelectedColor = UIColor.white
    public var dateCircleBackgroundUnselectedColor = UIColor.white

    // Capsule background color (whole cell background)
    public var capsuleBackgroundColor = UIColor(red: 0xD9/255.0, green: 0xE7/255.0, blue: 0xDE/255.0, alpha: 1.0)

    public init() {}
}

public struct DaySymbolsStyle {
    public var weekendColor = SystemColors.secondaryLabel
    public var weekDayColor = SystemColors.secondaryLabel
    public var font = UIFont.systemFont(ofSize: 12, weight: .regular)
    public init() {}
}

public struct SwipeLabelStyle {
    // Color for "SUN, NOV 16" label
    public var textColor = SystemColors.label
    public var font = UIFont.systemFont(ofSize: 15)
    public var leadingSpacing: CGFloat = 0
    public var dateFormat: String = "EEE, MMM d"  // Date format (e.g., "EEE, MMM d" -> "FRI, DEC 12" or "EEE d MMM" -> "FRI 12 DEC")
    public init() {}
}

public struct TimelineStyle {
    public var allDayStyle = AllDayViewStyle()
    public var timeIndicator = CurrentTimeIndicatorStyle()
    public var timeColor = SystemColors.secondaryLabel
    public var timeLabelTextColor = SystemColors.secondaryLabel  // Text color for time labels (10 AM, 11 AM, etc)
    public var timeLabelFont = UIFont.boldSystemFont(ofSize: 11)  // Font for time labels (10 AM, 11 AM, etc)
    public var separatorColor = SystemColors.systemSeparator
    public var backgroundColor = SystemColors.systemBackground
    public var font = UIFont.boldSystemFont(ofSize: 11)
    public var dateStyle : DateStyle = .system
    public var eventsWillOverlap: Bool = false
    public var minimumEventDurationInMinutesWhileEditing: Int = 30
    public var splitMinuteInterval: Int = 15
    public var verticalDiff: Double = 50
    public var verticalInset: Double = 10
    public var leadingInset: Double = 53  // Total left space (time labels + spacing)
    public var trailingInset: Double = 0
    public var timeColumnWidth: Double = 53  // Width of time labels column
    public var timeColumnOffset: Double = 2  // Left offset for time labels
    public var eventGap: Double = 0
    public var eventBorderWidth: CGFloat = 0  // Border width for events
    public var eventBorderColor: UIColor = .white  // Border color for events
    public var overlappingEventFixedWidth: Double = 50  // Fixed width for first N-1 overlapping events
    public var eventMaximumNumberOfLines: Int = 0  // Maximum number of lines for event text (0 = unlimited)
    public var minimumEventHeight: Double = 0  // Minimum height for events shorter than minimumEventHeightThreshold (0 = no minimum)
    public var minimumEventHeightThreshold: TimeInterval = 3600  // Duration threshold in seconds (default: 1 hour). Events shorter than this will use minimumEventHeight
    public init() {}
}

public struct CurrentTimeIndicatorStyle {
    public var color = SystemColors.systemRed  // Color for time label
    public var lineColor = SystemColors.systemRed  // Color for the line and circle
    public var font = UIFont.systemFont(ofSize: 11)
    public var dateStyle : DateStyle = .system
    public var leadingInset: Double = 53  // Leading inset for current time indicator
    public init() {}
}

public struct AllDayViewStyle {
    public var backgroundColor: UIColor = SystemColors.systemGray4
    public var allDayFont = UIFont.systemFont(ofSize: 12.0)
    public var allDayColor: UIColor = SystemColors.label
    public var eventBorderWidth: CGFloat = 0  // Border width for all-day events
    public var eventBorderColor: UIColor = .white  // Border color for all-day events
    public init() {}
}
