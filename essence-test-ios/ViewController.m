//
//  ViewController.m
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import "ViewController.h"
#import "EssenceService.h"
#import "DetailViewController.h"
#import "EssencePicture.h"


@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *developername;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Essence Test App";
    
  //  EssenceService *service = [[EssenceService alloc] initWithObjectName:@"ViewController"];
    tableData = [[NSMutableArray alloc] initWithCapacity:10];
    
    [self showPhotoList];
}


-(void)showPhotoList{
    
    [[EssenceService sharedInstance] fetchPhotoListWithCompletionBlock:^(NSArray *photoArray, NSError *error) {
        if (!error) {
            int i;
            for (i = 0; i < [photoArray count]; i++) {
                EssencePicture *pic = [[EssencePicture alloc] init];
                id dict = [photoArray objectAtIndex:i];
                pic.pictureId = dict[@"_id"];
                pic.name = dict[@"name"];
                [tableData addObject:pic];
            }
            [self.tableView reloadData];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:@"Cannot connect to Server"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];

            
        }
    }];
}

#pragma mark - TableView Data Source methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:    (NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:    (NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imagePhoto"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imagePhoto"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    EssencePicture *pic = [tableData objectAtIndex:indexPath.row];
    cell.textLabel.text = pic.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    EssencePicture *pic = [tableData objectAtIndex:indexPath.row];
    controller.photoId = pic.pictureId;
    [self.navigationController pushViewController:controller animated:YES];
    //NSLog(@"%d", indexPath.row); // you can see selected row number in your console;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
