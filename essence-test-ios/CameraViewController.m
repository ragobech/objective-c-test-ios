//
//  CameraViewController.m
//  essence-test-ios
//
//  Created by Chris Ragobeer on 2016-11-05.
//  Copyright © 2016 Essence. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewController.h"
#import "EssenceService.h"
#import "UIImage+Resize.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self setupDeveloperInformation];
}

-(void)setupLayout {
    
    self.title = @"Essence Test App";
    
    self.uploadImage.enabled = NO;
    UIBarButtonItem *photos = [[UIBarButtonItem alloc]initWithTitle:@"Photos" style:UIBarButtonItemStylePlain target:self action:@selector(goToPhotos)];
    self.navigationItem.rightBarButtonItem=photos;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Device has no camera"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}


-(void)setupDeveloperInformation{
    NSDictionary *infoPlistDict = [[NSBundle mainBundle] infoDictionary];
    NSString *name = infoPlistDict[@"developer_name"];
    self.developername.text = name;
    
}

-(void)uploadTask {
    
    UIImage *image = self.imageView.image;
    UIImage *image2 =  [UIImage resizeImage:image];
    self.imageView.image = image2;
    NSData *imageData = UIImagePNGRepresentation(image2);
    NSString *encodedString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    [[EssenceService sharedInstance] upload2Base64ImageWithCompletionBlock:encodedString :^(NSData *dataObject, NSURLResponse *response,NSError *error) {
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int responseCode = (int)[httpResponse statusCode];
        
        if (!error && responseCode == 200) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                               message:@"Upload Image successful"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
        else
        {
            
            
            NSLog(@"The response code: %i",responseCode);
            
            NSString *errorMsg = [NSString stringWithFormat:@"Error in uploading image, please try again. Status code : %i",responseCode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                               message:errorMsg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            });
            
        }
    }];
}

-(void)goToPhotos {
    
    ViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.uploadImage.enabled = YES;
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)uploadPhoto:(UIButton *)sender {
    
    NSData *data = UIImagePNGRepresentation(self.imageView.image);
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    NSLog(@"The string is %@",str);
    
    [self uploadTask];
    
}


- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
    //   self.uploadImage.enabled = YES;
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    //  self.uploadImage.enabled = YES;
}


@end
