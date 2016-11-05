//
//  DetailViewController.m
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import "DetailViewController.h"
#import "EssenceService.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showPhoto];

}

-(void)showPhoto{

    [[EssenceService sharedInstance] fetchPhotoBase64DataWithCompletionBlock:self.photoId :^(NSData *dataObject, NSError *error) {
        
        if (!error) {
          
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [[NSString alloc] initWithData:dataObject encoding:NSUTF8StringEncoding];
                NSData *data1 = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
                self.imageView.image = [UIImage imageWithData:data1];
            });
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
