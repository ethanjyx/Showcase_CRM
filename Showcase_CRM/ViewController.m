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
#import "Hanzi2Pinyin.h"
#import "DetailContactViewController.h"
#define thumbnailSize 75


@implementation ViewController {
    Company *globalSelectedCompany;
    Contact *globalSelectedContact;
}
@synthesize scrollView;
@synthesize tableView;
@synthesize names, mutableNames, mutableKeys;
@synthesize search;
@synthesize Segment;
@synthesize CompanyButton;
@synthesize ContactButton;




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
    if ( [Segment selectedSegmentIndex]==0) {
        CompanyButton.hidden=0;
        ContactButton.hidden=1;
        NSArray *fetchedCompaniesArrayLocal = [database getAllCompanies];
        NSLog(@"fetched %d", [fetchedCompaniesArrayLocal count]);
             for (int i = 0; i < [fetchedCompaniesArrayLocal count]; i++) {
                 Company *oneCompany = [fetchedCompaniesArrayLocal objectAtIndex:i];
                 
                 NSString *initKey;
                 if ([Hanzi2Pinyin hasChineseCharacter:oneCompany.name]) {
                     initKey = [[Hanzi2Pinyin convert:oneCompany.name] substringToIndex:1];
                 }
                 else {
                     initKey = [oneCompany.name substringToIndex:1];
                 }
                 NSString *key = [initKey uppercaseString];
                 //NSString *key = [oneCompany.name substringToIndex:1];
                 NSMutableArray *localNames = [names objectForKey:key];
                 if (localNames == nil) {
                     NSMutableArray *newArray = [[NSMutableArray alloc] init];
                     localNames = newArray;
                 }
                 [localNames addObject:oneCompany];
                 
                 
                 
                 NSArray *sortedNames = [localNames sortedArrayUsingComparator:^NSComparisonResult(Company* a, Company* b) {
                     
                     NSString *first = a.name;
                     NSString *second = b.name;
                     
                     if ([Hanzi2Pinyin hasChineseCharacter:first]) {
                         first = [Hanzi2Pinyin convert:first];
                         first = [NSString stringWithFormat:@"%@%@",@" ", first];
                     }
                     if ([Hanzi2Pinyin hasChineseCharacter:second]) {
                         second = [Hanzi2Pinyin convert:second];
                         second = [NSString stringWithFormat:@"%@%@",@" ", second];
                     }
                     
                     
                     
                     return [first compare:second];
                 }];
                 
                 NSMutableArray *sortedMutableArray = [NSMutableArray arrayWithArray:sortedNames];
                 
                 [names setObject:sortedMutableArray forKey:key];
             }
        }
    else {
        CompanyButton.hidden=1;
        ContactButton.hidden=0;
        NSArray *fetchedContactsArrayLocal = [database getAllContacts];
        NSLog(@"fetched %d", [fetchedContactsArrayLocal count]);
            for (int i = 0; i < [fetchedContactsArrayLocal count]; i++) {
                Contact *oneContact = [fetchedContactsArrayLocal objectAtIndex:i];
                
                NSString *name = [NSString stringWithFormat:@"%@%@",oneContact.lastname, oneContact.firstname];
                
                NSString *initKey;
                if ([Hanzi2Pinyin hasChineseCharacter:name]) {
                    initKey = [[Hanzi2Pinyin convert:name] substringToIndex:1];
                }
                else {
                    initKey = [name substringToIndex:1];
                }
                NSString *key = [initKey uppercaseString];

                NSMutableArray *localNames = [names objectForKey:key];
                if (localNames == nil) {
                    NSMutableArray *newArray = [[NSMutableArray alloc] init];
                    localNames = newArray;
                }
                [localNames addObject:oneContact];
                
                
                
                
                NSArray *sortedNames = [localNames sortedArrayUsingComparator:^NSComparisonResult(Contact* a, Contact* b) {
                    
                    NSString *first = [NSString stringWithFormat:@"%@%@",a.lastname, a.firstname];
                    NSString *second = [NSString stringWithFormat:@"%@%@",b.lastname, b.firstname];
                    
                    if ([Hanzi2Pinyin hasChineseCharacter:first]) {
                        first = [Hanzi2Pinyin convert:first];
                        first = [NSString stringWithFormat:@"%@%@",@" ", first];
                    }
                    if ([Hanzi2Pinyin hasChineseCharacter:second]) {
                        second = [Hanzi2Pinyin convert:second];
                        second = [NSString stringWithFormat:@"%@%@",@" ", second];
                    }
                    
                    
                    
                    return [first compare:second];
                }];
                
                NSMutableArray *sortedMutableArray = [NSMutableArray arrayWithArray:sortedNames];

                
                
                
                

                [names setObject:sortedMutableArray forKey:key];
            }
        }
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
    if ( [Segment selectedSegmentIndex]==0) {
        Company *oneCompany = [nameSection objectAtIndex:rowNumber];
        cell.textLabel.text=oneCompany.name;
    }
    else {
        Contact *oneContact = [nameSection objectAtIndex:rowNumber];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",oneContact.lastname, oneContact.firstname];
    }
    
    
    
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //NSLog(@"%@", cell.textLabel.text);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( [Segment selectedSegmentIndex]==0) { // company
        globalSelectedCompany = [[mutableNames objectForKey:[mutableKeys objectAtIndex:[indexPath section]]] objectAtIndex: [indexPath row]];
        [self performSegueWithIdentifier: @"detailSegue" sender:self];
    }
    else { // Contact
        globalSelectedContact = [[mutableNames objectForKey:[mutableKeys objectAtIndex:[indexPath section]]] objectAtIndex: [indexPath row]];
        [self performSegueWithIdentifier: @"detailContact" sender:self];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        sksViewController *detail = segue.destinationViewController;
        detail.company = globalSelectedCompany.name;
    }
    else if ([segue.identifier isEqualToString:@"detailContact"]) {
        DetailContactViewController *detailcontact=segue.destinationViewController;
        detailcontact.contact = globalSelectedContact;
    }
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
        if ([Segment selectedSegmentIndex]==0) {
            
            for(Company *company in array)
            {//数组内的元素循环对比
                if([company.name rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound)
                {
                    //rangeOfString方法是返回NSRange对象(包含位置索引和长度信息)
                    //NSCaseInsensitiveSearch是忽略大小写
                    //这里的代码会在name中找不到searchTerm时执行
                    

                    [toRemove addObject:company];
                
                    //找不到，把name添加到待删除列表
                }
                if (([Hanzi2Pinyin hasChineseCharacter:company.name] && [[Hanzi2Pinyin convertToAbbreviation:company.name] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location!=NSNotFound)) {
                    [toRemove removeObject:company];
                }
            }
            
            
        }
        else {
            
            for(Contact *contact in array)
            {//数组内的元素循环对比
                NSString *contactName = [NSString stringWithFormat:@"%@ %@",contact.lastname, contact.firstname];
                if([contactName rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location==NSNotFound)
                {
                    //rangeOfString方法是返回NSRange对象(包含位置索引和长度信息)
                    //NSCaseInsensitiveSearch是忽略大小写
                    //这里的代码会在name中找不到searchTerm时执行
                    [toRemove addObject:contact];
                    //找不到，把name添加到待删除列表
                }
                if (([Hanzi2Pinyin hasChineseCharacter:contactName] && [[Hanzi2Pinyin convertToAbbreviation:contactName] rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location!=NSNotFound)) {
                    [toRemove removeObject:contact];
                }

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

//选择公司或者联系人时加载不同的数据
- (IBAction)SegmentControl:(id)sender {
    [self updateTable];
}

- (IBAction)switchview:(id)sender {
    
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
