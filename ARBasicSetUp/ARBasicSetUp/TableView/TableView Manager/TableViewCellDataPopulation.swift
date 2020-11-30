import UIKit

protocol TableViewCellDataPopulation {
    func populate(_ data:Any)
}

protocol TableViewCellActionable :class {
    func didActionHappened(at sender:Any?, cell: UITableViewCell )
} 

protocol TableViewCellActionableCallBack:class {
    var delegate: TableViewCellActionable? { get set }
}

protocol TableViewCellParentIdentification {
    func parentViewController(_ controller:Any)
}
