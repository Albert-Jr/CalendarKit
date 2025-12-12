import UIKit

public final class SwipeLabelView: UIView, DayViewStateUpdating {
    public enum AnimationDirection {
        case Forward
        case Backward

        mutating func flip() {
            switch self {
            case .Forward:
                self = .Backward
            case .Backward:
                self = .Forward
            }
        }
    }

    public private(set) var calendar = Calendar.autoupdatingCurrent
    public weak var state: DayViewState? {
        willSet(newValue) {
            state?.unsubscribe(client: self)
        }
        didSet {
            state?.subscribe(client: self)
            updateLabelText()
        }
    }
    
    private func updateLabelText() {
        labels.first!.text = formattedDate(date: state!.selectedDate)
    }

    private var firstLabel: UILabel {
        labels.first!
    }

    private var secondLabel: UILabel {
        labels.last!
    }

    private var labels = [UILabel]()

    private var style = SwipeLabelStyle()

    public init(calendar: Calendar = Calendar.autoupdatingCurrent) {
        self.calendar = calendar
        super.init(frame: .zero)
        configure()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        for _ in 0...1 {
            let label = UILabel()
            label.textAlignment = .left
            labels.append(label)
            addSubview(label)
        }
        updateStyle(style)
    }

    public func updateStyle(_ newStyle: SwipeLabelStyle) {
        style = newStyle
        labels.forEach { label in
            label.textColor = style.textColor
            label.font = style.font
        }
        // Update the label text with the new date format
        if let currentState = state {
            labels.first?.text = formattedDate(date: currentState.selectedDate)
        }
        setNeedsLayout()
    }

    private func animate(_ direction: AnimationDirection) {
        let multiplier: Double = direction == .Forward ? -1 : 1
        let shiftRatio: Double = 30/375
        let screenWidth = bounds.width

        secondLabel.alpha = 0
        secondLabel.frame = bounds
        secondLabel.frame.origin.x -= Double(shiftRatio * screenWidth * 3) * multiplier

        UIView.animate(withDuration: 0.3, animations: {
            self.secondLabel.frame = self.bounds
            self.firstLabel.frame.origin.x += Double(shiftRatio * screenWidth) * multiplier
            self.secondLabel.alpha = 1
            self.firstLabel.alpha = 0
        }, completion: { _ in
            self.labels = self.labels.reversed()
        })
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        subviews.forEach { subview in
            subview.frame = bounds.insetBy(dx: style.leadingSpacing, dy: 0)
            subview.frame.origin.x = style.leadingSpacing
        }
    }

    // MARK: DayViewStateUpdating

    public func move(from oldDate: Date, to newDate: Date) {
        guard newDate != oldDate else {
            return
        }
        labels.last!.text = formattedDate(date: newDate)

        var direction: AnimationDirection = newDate > oldDate ? .Forward : .Backward

        let rightToLeft = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        if rightToLeft { direction.flip() }

        animate(direction)
    }

    private func formattedDate(date: Date) -> String {
        let timezone = calendar.timeZone
        let formatter = DateFormatter()
        formatter.dateFormat = style.dateFormat
        formatter.timeZone = timezone
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en_US")

        let formattedString = formatter.string(from: date)
        return style.uppercased ? formattedString.uppercased() : formattedString
    }
}
