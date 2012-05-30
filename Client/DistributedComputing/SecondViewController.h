//
//  SecondViewController.h
//  DistributedComputing
//
//  Created by Егор Быков on 19.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
- (IBAction)Edited:(UITextField *)sender;

@end
