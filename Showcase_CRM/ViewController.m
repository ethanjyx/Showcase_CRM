//
//  ViewController.m
//  Showcase_CRM
//
//  Created by Linfeng Shi on 6/10/14.
//  Copyright (c) 2014 Linfeng Shi. All rights reserved.
//
#import "ViewController.h"
#import "DetailViewController.h"
#import "UIImage+TKUtilities.h"
#import "DatabaseInterface.h"
#import "Company.h"

#define thumbnailSize 75
@implementation ViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
//@synthesize fetchedCompaniesArray;
@synthesize names=_names;
@synthesize mutableKeys=_mutableKeys;
@synthesize search = _search;
@synthesize mutableNames=_mutableNames;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    //[self setupArray];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  //  [self setTitle:@"Contacts"];
    //[self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPeoplePicker:)] autorelease]];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    //取得sortednames.plist绝对路径
    //sortednames.plist本身是一个NSDictionary,以键-值的形式存储字符串数组
    
    NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:path];
    //转换成NSDictionary对象
    self.names=dict;
    
    [self resetSearch];
    //重置
    [_tableView reloadData];
    //重新载入数据
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTableView:nil];
    [self setSearch:nil];
    [super viewDidUnload];
    self.names=nil;
    self.mutableKeys=nil;
    self.mutableNames=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/*-(void)setupArray{
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    fetchedCompaniesArray = [database getAllCompanies];
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //TODO: consider adjust this value later
    return [fetchedCompaniesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
 
    //---------- CELL BACKGROUND IMAGE -----------------------------
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *image = [UIImage imageNamed:@"LightGrey@2x.png"];
    imageView.image = image;
    cell.backgroundView = imageView;
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    Company *oneCompany = [fetchedCompaniesArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = oneCompany.name;
    
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.state = [datasource objectAtIndex:indexPath.row];
    detail.capital = [states objectForKey:detail.state];
    [self.navigationController pushViewController:detail animated:YES];
    
}
*/


//------------------TableView Cell Height------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}




   // Funtions for searchbar

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分组数量,即Array的数量
    return [_mutableKeys count];
    //
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([_mutableKeys count]==0) {
        return 0;
    }
    NSString *key=[_mutableKeys objectAtIndex:section];
    NSArray *nameSection=[_mutableNames objectForKey:key];
    return [nameSection count];
    //返回Array的大小
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section=[indexPath section];
    //分组号
    NSUInteger rowNumber=[indexPath row];
    //行号
    //即返回第section组，rowNumber行的UITableViewCell
    
    NSString *key=[_mutableKeys objectAtIndex:section];
    //取得第section组array的key
    NSArray *nameSection=[_mutableNames objectForKey:key];
    //通过key,取得Array
    
    static NSString * tableIdentifier=@"CellFromNib";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    cell.textLabel.text=[nameSection objectAtIndex:rowNumber];
    //从数组中读取字符串，设置text
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_mutableKeys count]==0) {
        return 0;
    }
    NSString *key=[_mutableKeys objectAtIndex:section];
    return key;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _mutableKeys;
    //通过key来索引
}

-(void)resetSearch
{//重置搜索
    _mutableNames=[_names mutableDeepCopy];
    //使用mutableDeepCopy方法深复制
    NSMutableArray *keyarr=[NSMutableArray new];
    [keyarr addObjectsFromArray:[[_names allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    //读取键，排序后存放可变数组
    _mutableKeys=keyarr;
    
}

-(void)handleSearchForTerm:(NSString *)searchTerm
{//处理搜索
    NSMutableArray *sectionToRemove=[NSMutableArray new];
    //分组待删除列表
    [self resetSearch];
    //先重置
    for(NSString *key in _mutableKeys)
    {//循环读取所有的数组
        NSMutableArray *array=[_mutableNames valueForKey:key];
        NSMutableArray *toRemove=[NSMutableArray new];
        //待删除列表
        for(NSString *name in array)
        {//数组内的元素循环对比
            if([name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound)
            {
                //rangeOfString方法是返回NSRange对象(包含位置索引和长度信息)
                //NSCaseInsensitiveSearch是忽略大小写
                //这里的代码会在name中找不到searchTerm时执行
                [toRemove addObject:name];
                //找不到，把name添加到待删除列表
            }
        }
        if ([array count]==[toRemove count]) {
            [sectionToRemove addObject:key];
            //如果待删除的总数和数组元素总数相同，把该分组的key加入待删除列表，即不显示该分组
        }
        [array removeObjectsInArray:toRemove];
        //删除数组待删除元素
    }
    [_mutableKeys removeObjectsInArray:sectionToRemove];
    //能过待删除的key数组删除数组
    [_tableView reloadData];
    //重载数据
    
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//TableView的项被选择前触发
    [_search resignFirstResponder];
    //搜索条释放焦点，隐藏软键盘
    return indexPath;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{//按软键盘右下角的搜索按钮时触发
    NSString *searchTerm=[searchBar text];
    //读取被输入的关键字
    [self handleSearchForTerm:searchTerm];
    //根据关键字，进行处理
    [_search resignFirstResponder];
    //隐藏软键盘
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{//搜索条输入文字修改时触发
    if([searchText length]==0)
    {//如果无文字输入
        [self resetSearch];
        [_tableView reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchText];
    //有文字输入就把关键字传给handleSearchForTerm处理
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{//取消按钮被按下时触发
    [self resetSearch];
    //重置
    searchBar.text=@"";
    //输入框清空
    [_tableView reloadData];
    [_search resignFirstResponder];
    //重新载入数据，隐藏软键盘
    
}









- (IBAction)showPeoplePicker:(id)sender
{
    TKPeoplePickerController *controller = [[TKPeoplePickerController alloc] initPeoplePicker];
    controller.actionDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - TKContactsMultiPickerControllerDelegate

- (void)tkPeoplePickerController:(TKPeoplePickerController*)picker didFinishPickingDataWithInfo:(NSArray*)contacts
{
    
    [self dismissModalViewControllerAnimated:YES];
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]])
            [(UIButton*)view removeFromSuperview];
    }
    
    [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TKContact *contact = (TKContact*)obj;
        
        //TODO: add new contacts to database and reload
        //[states setObject:contact.firstName forKey:contact.name];
        
        NSLog(@"%@", contact.name);
    }];
    
    [self.tableView reloadData];
}

- (void)tkPeoplePickerControllerDidCancel:(TKPeoplePickerController*)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

@end