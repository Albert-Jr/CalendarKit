import UIKit

public final class DateLabel: UILabel, DaySelectorItemProtocol {
    public var calendar = Calendar.autoupdatingCurrent {
        didSet {
            updateState()
        }
    }

    public var date = Date() {
        didSet {
            text = String(calendar.dateComponents([.day], from: date).day!)
            updateState()
        }
    }

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    public var selected: Bool = false {
        didSet {
            animate()
        }
    }

    private var style = DaySelectorStyle()

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 40, height: 40)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        isUserInteractionEnabled = true
        textAlignment = .center
        clipsToBounds = true
    }

    public func updateStyle(_ newStyle: DaySelectorStyle) {
        style = newStyle
        updateState()
    }

    func updateState() {
        text = String(component(component: .day, from: date))
        let today = isToday
        if selected {
            font = style.todayFont
            textColor = today ? style.todayActiveTextColor : style.activeTextColor
            backgroundColor = today ? style.todayActiveBackgroundColor : style.selectedBackgroundColor
        } else {
            let notTodayColor = isAWeekend(date: date) ? style.weekendTextColor : style.inactiveTextColor
            font = style.font
            textColor = today ? style.todayInactiveTextColor : notTodayColor
            backgroundColor = style.inactiveBackgroundColor
        }
    }

    private func component(component: Calendar.Component, from date: Date) -> Int {
        calendar.component(component, from: date)
    }

    private func isAWeekend(date: Date) -> Bool {
        let weekday = component(component: .weekday, from: date)
        if weekday == 7 || weekday == 1 {
            return true
        }
        return false
    }

    private func animate(){
        UIView.transition(with: self,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.updateState()
        },
                          completion: nil)
    }

    override public func layoutSubviews() {
        layer.cornerRadius = bounds.height / 2
    }
    override public func tintColorDidChange() {
        updateState()
    }
}

public final class DayColumnCell: UIView, DaySelectorItemProtocol {

    private let dayLabel = UILabel()
    private let dayBackgroundView = UIView()
    private let dateLabel = UILabel()

    public var date = Date() {
        didSet {
            updateState()
        }
    }

    public var calendar = Calendar.autoupdatingCurrent {
        didSet {
            updateState()
        }
    }

    public var selected: Bool = false {
        didSet {
            animate()
        }
    }

    private var style = DaySelectorStyle()

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 40, height: 70)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        addSubview(dayLabel)
        addSubview(dayBackgroundView)
        addSubview(dateLabel)

        dayLabel.textAlignment = .center
        dateLabel.textAlignment = .center

        layer.cornerRadius = 20
        clipsToBounds = true

        dayBackgroundView.backgroundColor = .white
        dayBackgroundView.clipsToBounds = true
    }

    public func updateStyle(_ newStyle: DaySelectorStyle) {
        style = newStyle
        updateState()
    }

    private func updateState() {
        // Update day label
        let daySymbols = calendar.shortStandaloneWeekdaySymbols
        let weekday = calendar.component(.weekday, from: date)
        dayLabel.text = daySymbols[weekday - 1]
        dayLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        // Update date label
        let day = calendar.component(.day, from: date)
        dateLabel.text = String(day)

        let isToday = calendar.isDateInToday(date)
        let isWeekend = isAWeekend(date: date)

        if selected {
            dateLabel.font = style.todayFont
            dayBackgroundView.backgroundColor = .white

            backgroundColor = UIColor(red: 0xD9/255.0, green: 0xE7/255.0, blue: 0xDE/255.0, alpha: 1.0)
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        } else {
            dateLabel.font = style.font
            dayBackgroundView.backgroundColor = .white

            backgroundColor = .clear
            dayLabel.textColor = .gray
            let textColor = isWeekend ? style.weekendTextColor : style.inactiveTextColor
            dateLabel.textColor = isToday ? style.todayInactiveTextColor : textColor
        }
    }

    private func isAWeekend(date: Date) -> Bool {
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 7 || weekday == 1
    }

    private func animate() {
        UIView.transition(with: dayBackgroundView,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
            self.updateState()
        },
                          completion: nil)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        // Day label at top, full width
        dayLabel.frame = CGRect(x: 0, y: 8, width: bounds.width, height: 16)

        // Date background is a 33x33 white circle, centered horizontally below day label
        let dateBackgroundSize: CGFloat = 33
        let dateBackgroundX = (bounds.width - dateBackgroundSize) / 2
        let dateBackgroundY: CGFloat = 30
        dayBackgroundView.frame = CGRect(x: dateBackgroundX, y: dateBackgroundY, width: dateBackgroundSize, height: dateBackgroundSize)
        dayBackgroundView.layer.cornerRadius = dateBackgroundSize / 2

        // Date label centered in the white circle background
        dateLabel.frame = dayBackgroundView.frame
    }

    override public func tintColorDidChange() {
        updateState()
    }
}
