//
//  ViewController.h
//  UITextField1_HW
//
//  Created by kluv on 22/12/2019.
//  Copyright © 2019 com.kluv.hw24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldsCollection;

@property (weak, nonatomic) IBOutlet UILabel *secondNameInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressInfoLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentHeight;


@end

