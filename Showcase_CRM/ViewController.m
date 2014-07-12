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
#import "sksViewController.h"

#define thumbnailSize 75


@implementation ViewController {
    NSString *globalSelectedCompany;
}
@synthesize scrollView;
@synthesize tableView;
@synthesize names, mutableNames, mutableKeys;
@synthesize search;




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    names = [[NSMutableDictionary alloc] init];
    mutableNames = [[NSMutableDictionary alloc] init];
    mutableKeys = [[NSMutableArray alloc] init];
    globalSelectedCompany = [[NSString alloc] init];
    [self setupNames];
    [self resetSearch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"updateTable" object:nil];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)updateTable
{
    [names removeAllObjects];
    [mutableNames removeAllObjects];
    [mutableKeys removeAllObjects];
    [self setupNames];
    [self resetSearch];
    [tableView reloadData];
}

- (void)setupNames
{
    DatabaseInterface *database = [DatabaseInterface databaseInterface];
    NSArray *fetchedCompaniesArrayLocal = [database getAllCompanies];
    NSLog(@"fetched %d", [fetchedCompaniesArrayLocal count]);
    for (int i = 0; i < [fetchedCompaniesArrayLocal count]; i++) {
        Company *oneCompany = [fetchedCompaniesArrayLocal objectAtIndex:i];
        NSString *key = [oneCompany.name substringToIndex:1];
        NSMutableArray *localNames = [names objectForKey:key];
        if (localNames == nil) {
            NSMutableArray *newArray = [[NSMutableArray alloc] init];
            localNames = newArray;
        }
        [localNames addObject:oneCompany.name];
        [names setObject:localNames forKey:key];
    }
    //NSLog(@"names %d", [names count]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mutableKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([mutableKeys count] == 0) {
        return 0;
    }
    NSString *key=[mutableKeys objectAtIndex:section];
    NSArray *nameSection=[mutableNames objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section=[indexPath section];
    //分组号
    NSUInteger rowNumber=[indexPath row];
    //行号
    //即返回第section组，rowNumber行的UITableViewCell

    NSString *key=[mutableKeys objectAtIndex:section];
    //取得第section组array的key
    NSArray *nameSection=[mutableNames objectForKey:key];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
    // set text
    cell.textLabel.text=[nameSection objectAtIndex:rowNumber];
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //NSLog(@"%@", cell.textLabel.text);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    globalSelectedCompany = [self getCompanyNameAtIndexPath:indexPath];
    [self performSegueWithIdentifier: @"detailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        sksViewController *detail = segue.destinationViewController;
        detail.company = globalSelectedCompany;
    }
}


-(NSString*)getCompanyNameAtIndexPath: (NSIndexPath*) indexPath {
    return [[mutableNames objectForKey:[mutableKeys objectAtIndex:[indexPath section]]] objectAtIndex: [indexPath row]];
}

-(void)resetSearch
{
    //重置搜索
    mutableNames=[names mutableDeepCopy];
    NSMutableArray *keyarr=[NSMutableArray new];
    [keyarr addObjectsFromArray:[[names allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    mutableKeys=keyarr;
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([mutableKeys count]==0) {
        return 0;
    }
    NSString *key=[mutableKeys objectAtIndex:section];
    return key;
}

-(void)handleSearchForTerm:(NSString *)searchTerm
{//处理搜索
    NSMutableArray *sectionToRemove=[NSMutableArray new];
    //分组待删除列表
    [self resetSearch];
    //先重置
    for(NSString *key in mutableKeys)
    {//循环读取所有的数组
        NSMutableArray *array=[mutableNames valueForKey:key];
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
    [mutableKeys removeObjectsInArray:sectionToRemove];
    //能过待删除的key数组删除数组
    [tableView reloadData];
    //重载数据
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//TableView的项被选择前触发
    [search resignFirstResponder];
    //搜索条释放焦点，隐藏软键盘
    return indexPath;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{//按软键盘右下角的搜索按钮时触发
    NSString *searchTerm=[searchBar text];
    //读取被输入的关键字
    [self handleSearchForTerm:searchTerm];
    //根据关键字，进行处理
    [search resignFirstResponder];
    //隐藏软键盘
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{//搜索条输入文字修改时触发
    if([searchText length]==0)
    {//如果无文字输入
        [self resetSearch];
        [tableView reloadData];
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
    [tableView reloadData];
    [search resignFirstResponder];
    //重新载入数据，隐藏软键盘
}









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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



// 导入， 弹出contacts的选择框
- (IBAction)showPeoplePicker:(id)sender
{
    TKPeoplePickerController *controller = [[TKPeoplePickerController alloc] initPeoplePicker];
    controller.actionDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

// 导出
- (IBAction)exportContacts:(id)sender {
    ABAddressBookRef addressBook = ABAddressBookCreate(); // create address book record
    ABRecordRef person = ABPersonCreate(); // create a person
    
    NSString *phone = @"0123456789"; // the phone number to add
    
    //Phone number is a list of phone number, so create a multivalue
    ABMutableMultiValueRef phoneNumberMultiValue =
    ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue ,(__bridge CFTypeRef)(phone),kABPersonPhoneMobileLabel, NULL);
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, @"FirstName" , nil); // first name of the new person
    ABRecordSetValue(person, kABPersonLastNameProperty, @"AAA", nil); // his last name
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil); // set the phone number property
    ABAddressBookAddRecord(addressBook, person, nil); //add the new person to the record
    
    ABAddressBookSave(addressBook, nil); //save the record
    
    CFRelease(person); // relase the ABRecordRef  variable
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