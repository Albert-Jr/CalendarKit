import UIKit
import CalendarKit

final class CustomCalendarExampleController: DayViewController {
    var data = [["Breakfast at Tiffany's",
                 "New York, 5th avenue"],

                ["Workout",
                 "Tufteparken"],

                ["Meeting with Alex",
                 "Home",
                 "Oslo, Tjuvholmen"],

                ["Beach Volleyball",
                 "Ipanema Beach",
                 "Rio De Janeiro"],

                ["WWDC",
                 "Moscone West Convention Center",
                 "747 Howard St"],

                ["Google I/O",
                 "Shoreline Amphitheatre",
                 "One Amphitheatre Parkway"],

                ["✈️️ to Svalbard ❄️️❄️️❄️️❤️️",
                 "Oslo Gardermoen"],

                ["💻📲 Developing CalendarKit",
                 "🌍 Worldwide"],

                ["Software Development Lecture",
                 "Mikpoli MB310",
                 "Craig Federighi"],

    ]

    var generatedEvents = [EventDescriptor]()
    var alreadyGeneratedSet = Set<Date>()

    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]

    private lazy var dateIntervalFormatter: DateIntervalFormatter = {
        let dateIntervalFormatter = DateIntervalFormatter()
        dateIntervalFormatter.dateStyle = .none
        dateIntervalFormatter.timeStyle = .short

        return dateIntervalFormatter
    }()

    override func loadView() {
        calendar.timeZone = TimeZone(identifier: "Europe/Paris")!

        dayView = DayView(calendar: calendar)

        // Create a container view and add dayView with spacing
        let containerView = UIView()
      containerView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view = containerView

        containerView.addSubview(dayView)
        dayView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            dayView.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            dayView.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            dayView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CalendarKit Demo"
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true

        // Example: Customize fonts and colors
        var style = CalendarStyle()

        // Whole calendar background color
        style.backgroundColor = .white
        style.header.backgroundColor = .white  // Header background
        style.timeline.backgroundColor = .white  // Timeline background
        style.cornerRadius = 24  // Corner radius for the whole calendar
        style.header.topSpacing = 16  // Top spacing for header
        style.header.separatorHidden = true  // Hide the separator line below the header

        // Fonts
        style.header.daySelector.dayNameFont = UIFont.systemFont(ofSize: 12, weight: .regular) // Mon-Sun font
        style.header.daySelector.font = UIFont.systemFont(ofSize: 12, weight: .regular) // Date numbers (1-31)
        style.header.daySelector.todayFont = UIFont.systemFont(ofSize: 12, weight: .semibold) // Today's date

        // Sun - Sat label colors
        style.header.daySelector.dayNameSelectedColor = .black // Selected day name color
        style.header.daySelector.dayNameUnselectedColor = .gray // Unselected day name color

        // 1 - 31 label colors
        style.header.daySelector.dateNumberSelectedColor = .white // Selected date number color
        style.header.daySelector.dateNumberUnselectedColor = .black // Unselected date number color
        style.header.daySelector.dateNumberCurrentDayColor = .red // Current day color (e.g., Nov 19 if today). If nil, uses selected/unselected colors

        // Background color for the circle around 1 - 31 label
        style.header.daySelector.dateCircleBackgroundSelectedColor = .orange // Selected state
        style.header.daySelector.dateCircleBackgroundUnselectedColor = .green // Unselected state

        // The whole background of the capsule (Sun - Sat label and 1 - 31 label)
        style.header.daySelector.capsuleBackgroundColor = .yellow //UIColor(red: 0xD9/255.0, green: 0xE7/255.0, blue: 0xDE/255.0, alpha: 1.0)

        // Label color for "SUN, NOV 16" label
        style.header.swipeLabel.textColor = .purple
        style.header.swipeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        style.header.swipeLabel.leadingSpacing = 0  // Leading spacing for swipe label

        // Navigation button icons (chevron left/right)
        if #available(iOS 13.0, *) {
            style.header.previousWeekIcon = UIImage(systemName: "chevron.left")
            style.header.nextWeekIcon = UIImage(systemName: "chevron.right")
        }
        style.header.navigationButtonColor = .green
        style.header.navigationButtonLeadingSpacing = 0  // Leading spacing for left button
        style.header.navigationButtonTrailingSpacing = 0 // Trailing spacing for right button

        // Timeline (calendar view below) leading and trailing spacing
        style.timeline.timeColumnOffset = 0  // Align time labels with "TUE, NOV 18" header (same as swipe label leading)
        style.timeline.timeColumnWidth = 53   // Width for time labels (e.g., "9 AM")
        style.timeline.leadingInset = 53     // Total left space (time column + spacing before events)
        style.timeline.trailingInset = 16     // Right margin for timeline
        style.timeline.timeLabelTextColor = .black  // Text color for time labels (10 AM, 11 AM, etc)
        style.timeline.timeLabelFont = UIFont.systemFont(ofSize: 11, weight: .regular)  // Font for time labels (10 AM, 11 AM, etc)
        style.timeline.timeIndicator.leadingInset = 65  // Leading inset for current time indicator
        style.timeline.timeIndicator.color = .green  // Color for current time label text
        style.timeline.timeIndicator.lineColor = .blue  // Color for current time indicator line and circle
        style.timeline.eventsWillOverlap = true  // Enable overlapping for events with same start time
        style.timeline.eventGap = 0  // Gap between events (0 for full overlap)
        style.timeline.overlappingEventFixedWidth = 50  // Fixed width for first N-1 overlapping events (last event takes remaining space)
        style.timeline.eventMaximumNumberOfLines = 1  // Maximum number of lines for event text (1 = single line, 0 = unlimited)

        // Event borders
        style.timeline.eventBorderWidth = 2   // White border for events
        style.timeline.eventBorderColor = .purple
        style.timeline.allDayStyle.eventBorderWidth = 2  // White border for all-day events
        style.timeline.allDayStyle.eventBorderColor = .white
        
        style.timeline.minimumEventHeight = 80 // Minimum height in points
        style.timeline.minimumEventHeightThreshold = 3600 // 1 hour in seconds (default)

        dayView.updateStyle(style)

        reloadData()
    }

    // MARK: EventDataSource

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if !alreadyGeneratedSet.contains(date) {
            alreadyGeneratedSet.insert(date)
            generatedEvents.append(contentsOf: generateEventsForDate(date))
        }
        return generatedEvents
    }

    private func generateEventsForDate(_ date: Date) -> [EventDescriptor] {
        var workingDate = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1...15), to: date)!
        var events = [Event]()

        for i in 0...4 {
            let event = Event()

            let duration = Int.random(in: 60 ... 160)
            event.dateInterval = DateInterval(start: workingDate, duration: TimeInterval(duration * 60))

            let info = data.randomElement() ?? []
            let attributedInfo = NSMutableAttributedString(
              string: info.reduce("", { $0 + $1 + "\n" }),
              attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .semibold)]
            )

            let timezone = dayView.calendar.timeZone
            print(timezone)

            let durationText = dateIntervalFormatter.string(
              from: event.dateInterval.start,
              to: event.dateInterval.end
            )
          
            let color = colors.randomElement() ?? .red
          
            let durationAttributedText: NSMutableAttributedString = {
              var attributedString: NSMutableAttributedString!
              if #available(iOS 13.0, *) {
                let clockIcon = NSTextAttachment()
                let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .thin, scale: .small)
                let image = UIImage(systemName: "clock", withConfiguration: config)
                clockIcon.image = image
                let text = NSMutableAttributedString(attachment: clockIcon)
                attributedString = text
              } else {
                attributedString = NSMutableAttributedString(string: "")
              }
              attributedString.addAttribute(
                .paragraphStyle,
                value: {
                  let paragraphStyle = NSMutableParagraphStyle()
                  paragraphStyle.paragraphSpacingBefore = 5
                  return paragraphStyle
                }(),
                range: NSRange(location: 0, length: attributedString.string.count)
              )
              return attributedString
            }()
            let attributedDuration = NSAttributedString(
              string: String(format: " %@", durationText),
              attributes: [.font: UIFont.systemFont(ofSize: 11, weight: .light)]
            )
            durationAttributedText.append(attributedDuration)
            attributedInfo.append(durationAttributedText)
            event.attributedText = attributedInfo
            event.color = color
            event.isAllDay = Bool.random()
            event.lineBreakMode = .byTruncatingTail

            events.append(event)

            let nextOffset = Int.random(in: 40 ... 250)
            workingDate = Calendar.current.date(byAdding: .minute, value: nextOffset, to: workingDate)!
            event.userInfo = String(i)
        }

        print("Events for \(date)")
        return events
    }

    // MARK: DayViewDelegate

    private var createdEvent: EventDescriptor?

    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }

    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        endEventEditing()
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
        beginEditing(event: descriptor, animated: true)
        print(Date())
    }

    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        endEventEditing()
        print("Did Tap at date: \(date)")
    }

    override func dayViewDidBeginDragging(dayView: DayView) {
        endEventEditing()
        print("DayView did begin dragging")
    }

    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }

    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
    }

    override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
        print("Did long press timeline at date \(date)")
        // Cancel editing current event and start creating a new one
        endEventEditing()
        let event = generateEventNearDate(date)
        print("Creating a new event")
        create(event: event, animated: true)
        createdEvent = event
    }

    private func generateEventNearDate(_ date: Date) -> EventDescriptor {
        let duration = (60...220).randomElement()!
        let startDate = Calendar.current.date(byAdding: .minute, value: -Int(Double(duration) / 2), to: date)!
        let event = Event()

        event.dateInterval = DateInterval(start: startDate, duration: TimeInterval(duration * 60))

        var info = data.randomElement()!

        info.append(dateIntervalFormatter.string(from: event.dateInterval)!)
        event.text = info.reduce("", {$0 + $1 + "\n"})
        event.color = colors.randomElement()!
        event.editedEvent = event

        return event
    }

    override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
        print("did finish editing \(event)")
        print("new startDate: \(event.dateInterval.start) new endDate: \(event.dateInterval.end)")

        if let _ = event.editedEvent {
            event.commitEditing()
        }

        if let createdEvent = createdEvent {
            createdEvent.editedEvent = nil
            generatedEvents.append(createdEvent)
            self.createdEvent = nil
            endEventEditing()
        }

        reloadData()
    }
}
