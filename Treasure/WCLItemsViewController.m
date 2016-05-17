//
//  WCLItemsViewController.m
//  Treasure
//
//  Created by Lv on 16/5/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "WCLItemsViewController.h"
#import "WCLItem.h"
#import "WCLItemStore.h"
#import "WCLDetailViewController.h"
#import "WCLItemCell.h"

@interface WCLItemsViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@end

@implementation WCLItemsViewController

static NSString *reuseIdentifier = @"WCLItemCell";

# pragma mark - view life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"liatViewDidLoad");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
/*    取消初始化方法，点击new来添加行
 *   for (int i = 0; i < 5; i++) {
 *       [[WCLItemStore sharedStore] createItem];
 *   }
 */
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    使用自定义nib文件来加载cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WCLItemCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = @"Treasure List";
    
    UIBarButtonItem *addBbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
    self.navigationItem.rightBarButtonItem = addBbi;
    
    UIBarButtonItem *editBbi = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEditingMode:)];
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = editBbi;
/*
 *  设置tableView的整体头部视图(tableHeaderView)此处不需要，所以注释掉

    UIView *header = self.headerView;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 400, 50)];
    header.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 100, 50)];
    label.text = @"Treasure List";
    [header addSubview:label];
    [self.tableView setTableHeaderView:header];
    NSLog(@"setTableHeaderView");
*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"listViewWillAppear");
    [self.tableView reloadData];
}

#pragma mark - lazy instantiation
/*
//lazy instantiation  延迟实例化  ｀self.headerView｀时调用
-(UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil] firstObject];
    }
    return _headerView;
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[WCLItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    WCLItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *items = [[WCLItemStore sharedStore] allItems];
    WCLItem *item = items[indexPath.row];
    
//    cell.textLabel.text = [item description];
    cell.labelName.text = item.itemName;
    cell.labelSerialNumber.text = item.serialNumber;
    cell.labelValue.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    
    cell.imageThumbnail.image = item.thumbnail;
    
    cell.actionBlock = ^{
        NSLog(@"展示%@的图片", item.itemName);
    };
    
    NSLog(@"%@", item.description);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[WCLItemStore sharedStore] allItems];
        WCLItem *item = items[indexPath.row];
        
        [[WCLItemStore sharedStore] removeItem:item];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[WCLItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCLDetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WCLDetailViewController"];
//    WCLDetailViewController *dvc = [[WCLDetailViewController alloc] initForNewItem:NO];
//    [dvc initForNewItem:NO];
    
    
    NSArray *items = [[WCLItemStore sharedStore] allItems];
    WCLItem *selectedItem = items[indexPath.row];
    
    dvc.item = selectedItem;
    
//    [self.navigationController presentViewController:dvc animated:YES completion:nil];//这种写法是不对的，当使用storyboard布局的时候应该使用上面这种跳转方式
    [self.navigationController pushViewController:dvc animated:YES];
}


/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    使用nib文件初始化view(使用｀self.｀的方式来调用延迟实例化方法)
    UIView *view = self.headerView;
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
*/

#pragma mark - Actions

- (IBAction)toggleEditingMode:(UIBarButtonItem *)sender {
    if (self.tableView.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [sender setStyle:UIBarButtonItemStylePlain];
        [sender setTitle:@"编辑"];
        [self.tableView setEditing:NO animated:YES];
    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [sender setTitle:@"完成"];
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addNewItem:(UIButton *)sender {
    
    WCLItem *newItem = [[WCLItemStore sharedStore] createItem];
    
    NSInteger lastRow = [[[WCLItemStore sharedStore] allItems] indexOfObject:newItem];
    
//    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    WCLDetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WCLDetailViewController"];
    dvc.item = newItem;
    [self.navigationController pushViewController:dvc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
