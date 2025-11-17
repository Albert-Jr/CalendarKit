import UIKit

//public final class DayColumnCell: UIView, DaySelectorItemProtocol {
//
//    private let dayLabel = UILabel()
//    private let dateLabel = UILabel()
//    private let containerView = UIView()
//
//    public var date = Date() {
//        didSet {
//            updateState()
//        }
//    }
//
//    public var calendar = Calendar.autoupdatingCurrent {
//        didSet {
//            updateState()
//        }
//    }
//
//    public var selected: Bool = false {
//        didSet {
//            animate()
//        }
//    }
//
//    private var style = DaySelectorStyle()
//
//    override public var intrinsicContentSize: CGSize {
//        CGSize(width: 50, height: 70)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configure()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        configure()
//    }
//
//    private func configure() {
//        addSubview(containerView)
//        [dayLabel, dateLabel].forEach { containerView.addSubview($0) }
//
//        dayLabel.textAlignment = .center
//        dateLabel.textAlignment = .center
//
//        containerView.layer.cornerRadius = 25
//        containerView.clipsToBounds = true
//    }
//
//    public func updateStyle(_ newStyle: DaySelectorStyle) {
//        style = newStyle
//        updateState()
//    }
//
//    private func updateState() {
//        // Update day label
//        let daySymbols = calendar.shortStandaloneWeekdaySymbols
//        let weekday = calendar.component(.weekday, from: date)
//        dayLabel.text = daySymbols[weekday - 1]
//        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//
//        // Update date label
//        let day = calendar.component(.day, from: date)
//        dateLabel.text = String(day)
//
//        let isToday = calendar.isDateInToday(date)
//        let isWeekend = isAWeekend(date: date)
//
//        if selected {
//            dateLabel.font = style.todayFont
//            containerView.backgroundColor = isToday ? style.todayActiveBackgroundColor : style.selectedBackgroundColor
//
//            dayLabel.textColor = isToday ? style.todayActiveTextColor : style.activeTextColor
//            dateLabel.textColor = isToday ? style.todayActiveTextColor : style.activeTextColor
//        } else {
//            dateLabel.font = style.font
//            containerView.backgroundColor = style.inactiveBackgroundColor
//
//            let textColor = isWeekend ? style.weekendTextColor : style.inactiveTextColor
//            dayLabel.textColor = isToday ? style.todayInactiveTextColor : textColor
//            dateLabel.textColor = isToday ? style.todayInactiveTextColor : textColor
//        }
//    }
//
//    private func isAWeekend(date: Date) -> Bool {
//        let weekday = calendar.component(.weekday, from: date)
//        return weekday == 7 || weekday == 1
//    }
//
//    private func animate() {
//        UIView.transition(with: containerView,
//                          duration: 0.3,
//                          options: .transitionCrossDissolve,
//                          animations: {
//            self.updateState()
//        },
//                          completion: nil)
//    }
//
//    override public func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Container takes up the full view
//        containerView.frame = bounds
//
//        // Day label at top
//        dayLabel.frame = CGRect(x: 0, y: 8, width: bounds.width, height: 16)
//
//        // Date label below
//        dateLabel.frame = CGRect(x: 0, y: 28, width: bounds.width, height: 32)
//    }
//
//    override public func tintColorDidChange() {
//        updateState()
//    }
//}
