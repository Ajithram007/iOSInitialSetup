import UIKit

class TableViewHandler: NSObject, UITableViewDataSource, UITableViewDelegate , TableViewCellActionable {
    
    var data: [TableViewCellData]?

    weak var delegate: TableViewHandlerProtocol?
    
     func configureTableview(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        
        //  If needed move the lines below out of the constructor
        prepare()
        self.delegate?.handler(self, registerTableViewCells: tableView)
        tableView.reloadData()
    }
    
     func configureDelegate(_ delegate: TableViewHandlerProtocol) {
        self.delegate = delegate
    }
    
    init(_ delegate: TableViewHandlerProtocol, tableView:UITableView) {
        super.init()
        configureDelegate(delegate)
        configureTableview(tableView)
    }
    
    func prepare() -> Void {
        prepareData()
    }
    
    func prepareData() -> Void {
        data = delegate?.prepareDataSourceForHandler(self)
    }

    func reloadData(dataModel:[TableViewCellData],tableView: UITableView) -> Void {
        
        DispatchQueue.main.async { [unowned self] in
            self.data = nil
            self.data = dataModel
            tableView.reloadData()
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cellData = data?[indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: cellData.identifier)
            
            else {
                return UITableViewCell()
            }
        
        if let dataPopulationCell = cell as? TableViewCellDataPopulation {
            dataPopulationCell.populate(cellData.data)
        }
        
        if let actionableCallBack = cell as? TableViewCellActionableCallBack {
            actionableCallBack.delegate = self
        }
        
        if let expertMatchCell = cell as? TableViewCellParentIdentification {
            expertMatchCell.parentViewController(self.delegate as Any)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.handler?(self, didActionHappenedAt: tableView.cellForRow(at: indexPath), cell: tableView.cellForRow(at: indexPath) ?? UITableViewCell())
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func didActionHappened(at sender:Any?, cell: UITableViewCell ) {
        self.delegate?.handler?(self, didActionHappenedAt: sender, cell: cell)
    }
}


@objc
protocol TableViewHandlerProtocol {
    func handler(_ handler:TableViewHandler, registerTableViewCells tableView:UITableView)
    func prepareDataSourceForHandler(_ handler: TableViewHandler) -> [TableViewCellData]
    
    @objc optional
    func handler(_ handler:TableViewHandler, didActionHappenedAt sender:Any?, cell: UITableViewCell)

}

class TableViewCellData: NSObject {
    var identifier: String = ""
    var data: Any
    
    init(_ identifier:String, data:Any) {
        self.identifier = identifier
        self.data = data
    }
}

class RegisterTableViewCells: NSObject {
    var nibName: String = "nibName"
    var reuseIdentifier: String = "reuseIdentifier"
    
    init(nibName: String, reuseIdentifier: String) {
        self.nibName = nibName
        self.reuseIdentifier = reuseIdentifier
    }
}
