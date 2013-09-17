//
//  ViewController.h
//  WAAD-Test
//
//  Created by Chris Risner on 9/10/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
- (IBAction)tappedAuthenticate:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
- (IBAction)tappedGetToken:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnGetToken;
@property (weak, nonatomic) IBOutlet UIButton *btnFetchItems;
- (IBAction)tappedFetchItems:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddItem;
- (IBAction)tappedAddItem:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtTodo;
@property (weak, nonatomic) IBOutlet UIButton *btnDecodeToken;
- (IBAction)tappedDecodeToken:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblUser;

@end
