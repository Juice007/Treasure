//
//  WCLDetailViewController.m
//  Treasure
//
//  Created by Lv on 16/5/10.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "WCLDetailViewController.h"
#import "WCLItem.h"
#import "WCLImageStore.h"

@interface WCLDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSerial;
@property (weak, nonatomic) IBOutlet UITextField *textFieldValue;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation WCLDetailViewController

#pragma mark - view life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"detailViewWillAppear");
    WCLItem *item = self.item;
    
    self.textFieldName.text = item.itemName;
    self.textFieldSerial.text = item.serialNumber;
    self.textFieldValue.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.labelDate.text = [dateFormatter stringFromDate:item.dateCreated];
    
//    让每次detail视图出现时，都尝试加载图片，倘若没有图片则显示为空。将临时存储的图片存在字典中（亦即内存中，程序重新启动又会被销毁）
    NSString *key = self.item.itemKey;
    UIImage *imageToDisplay = [[WCLImageStore sharedStore] imageForKey:key];
    self.imageView.image = imageToDisplay;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.item.itemName;
    
//    使用代码添加UIImageView
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    
    self.imageView = iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{
                              @"imageView":self.imageView,
                              @"labelDate":self.labelDate,
                              @"toolBar":self.toolBar
                              };
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                             options:0 metrics:nil views:nameMap];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[labelDate]-8-[imageView]-8-[toolBar]"
                                                                           options:0 metrics:nil views:nameMap];
    
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    NSLog(@"detailViewDidDisappear");
    
    WCLItem *item = self.item;
    item.itemName = self.textFieldName.text;
    item.serialNumber = self.textFieldSerial.text;
    item.valueInDollars = [self.textFieldValue.text intValue];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)takePicture:(UIBarButtonItem *)sender
{
//    防止点击两次拍照按钮应用崩溃
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
 
    /*
     * popover中弹出alertController
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"打开方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [ac addAction:[UIAlertAction actionWithTitle:@"从相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }]];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [ac addAction:[UIAlertAction actionWithTitle:@"从图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }]];
    }
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        code
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
    */
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
 
    
//    不直接模态弹出。针对iPad设备使用UIPopoverController。
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        创建UIPopoverController
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
//        显示UIPopoverController
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    通过info字典来获取选择的照片**VIM**[因为info中可能是图片，也可能是视频所以使用字典来进行存储]
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.item setThumbnailFromImage:image];
    
//    把image存到ImageStore.
    [[WCLImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    
    self.imageView.image = image;
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"用户手动关闭popover");
    self.imagePickerPopover = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
# warning textFieldShouldReturn 不执行
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

/*

#pragma mark - Implentation

- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
    }
    return self;
}
 
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
