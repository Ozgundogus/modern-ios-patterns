#if canImport(UIKit)
import BrewDomain
import BrewUI
import MVVMCViewModels
import UIKit

public final class OrderOptionsViewController: UIViewController {
    let viewModel: OrderOptionsViewModel

    private let quantityLabel = UILabel()
    private let totalLabel = UILabel()

    public init(viewModel: OrderOptionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Order"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction { [weak self] _ in
            self?.viewModel.cancel()
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Review", primaryAction: UIAction { [weak self] _ in
            self?.viewModel.continueToReview()
        })

        let name = UILabel()
        name.text = "\(viewModel.coffee.name) · \(viewModel.coffee.formattedPrice) per 250 g"
        name.font = .preferredFont(forTextStyle: .headline)

        totalLabel.font = .preferredFont(forTextStyle: .title2)

        addContentStack([name, makeSizeControl(), makeGrindButton(), makeQuantityRow(), totalLabel])

        observe { [weak self] in self?.render() }
    }

    private func render() {
        quantityLabel.text = "Quantity: \(viewModel.quantity)"
        totalLabel.text = "Total: \(viewModel.order.formattedTotal)"
    }

    private func makeSizeControl() -> UIView {
        let control = UISegmentedControl(items: Order.Size.allCases.map(\.displayName))
        control.selectedSegmentIndex = Order.Size.allCases.firstIndex(of: viewModel.size) ?? 0
        control.addAction(UIAction { [weak self, weak control] _ in
            guard let self, let control else { return }
            viewModel.size = Order.Size.allCases[control.selectedSegmentIndex]
        }, for: .valueChanged)
        return control
    }

    private func makeGrindButton() -> UIView {
        let actions = Order.Grind.allCases.map { grind in
            UIAction(title: grind.displayName, state: grind == viewModel.grind ? .on : .off) { [weak self] _ in
                self?.viewModel.grind = grind
            }
        }
        let button = UIButton(configuration: .gray())
        button.menu = UIMenu(title: "Grind", children: actions)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }

    private func makeQuantityRow() -> UIView {
        let stepper = UIStepper()
        stepper.minimumValue = Double(Order.quantityRange.lowerBound)
        stepper.maximumValue = Double(Order.quantityRange.upperBound)
        stepper.value = Double(viewModel.quantity)
        stepper.addAction(UIAction { [weak self, weak stepper] _ in
            guard let self, let stepper else { return }
            viewModel.quantity = Int(stepper.value)
        }, for: .valueChanged)
        let row = UIStackView(arrangedSubviews: [quantityLabel, stepper])
        row.distribution = .equalSpacing
        return row
    }
}
#endif
