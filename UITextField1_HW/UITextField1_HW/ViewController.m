//
//  ViewController.m
//  UITextField1_HW
//
//  Created by kluv on 22/12/2019.
//  Copyright © 2019 com.kluv.hw24. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    regFormLastName         = 0,
    regFormFirstName        = 1,
    regFormLogin            = 2,
    regFormPass             = 3,
    regFormAge              = 4,
    regFormPhone            = 5,
    regFormEmail            = 6,
    regFormAddress          = 11
} textFieldsTypes;

@interface ViewController ()

@property (weak, nonatomic) UITextField* activeField;
@property (assign, nonatomic) CGPoint lastOffset;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (assign, nonatomic) BOOL willMakeKeyboardOffset;

@property (strong, nonatomic) NSMutableDictionary* mapingTextFieldsLabelsDictionary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar.barStyle = UIBarStyleBlack;
//    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                         [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
//    [numberToolbar sizeToFit];
        
    UITextField* firstTextField;
    
    for (UITextField* textField in self.textFieldsCollection) {

        if ([self.textFieldsCollection indexOfObject:textField] == 0) {
            firstTextField = textField;
        }

        textField.delegate = self;

//        if (textField.tag == regFormAge || textField.tag == regFormPhone) {
//            textField.inputAccessoryView = numberToolbar;
//        }
        
    }
    
    [firstTextField becomeFirstResponder];
    
    [self setMapingTextFieldsLabelsDictionary];
    
}

- (void) setMapingTextFieldsLabelsDictionary {
    
    self.mapingTextFieldsLabelsDictionary = [NSMutableDictionary dictionary];
    
    [self.mapingTextFieldsLabelsDictionary setObject:self.secondNameInfoLabel forKey: [@(regFormLastName) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.firstNameInfoLabel forKey: [@(regFormFirstName) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.loginInfoLabel forKey: [@(regFormLogin) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.ageInfoLabel forKey: [@(regFormAge) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.phoneInfoLabel forKey: [@(regFormPhone) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.emailInfoLabel forKey: [@(regFormEmail) stringValue]];
    [self.mapingTextFieldsLabelsDictionary setObject:self.addressInfoLabel forKey: [@(regFormAddress) stringValue]];
    
}

- (void)viewWillAppear:(BOOL)animated {
        
    [super viewWillAppear:YES];
    
    [self registerNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    [self deregisterNotifications];
    
}

- (void)registerNotifications {
 
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(keyboardWasShown:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(keyboardWillBeHidden:)
               name:UIKeyboardWillHideNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(textFieldDidChange:)
               name:UITextFieldTextDidChangeNotification
             object:nil];
 
}
 
- (void)deregisterNotifications {
 
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self
                  name:UIKeyboardWillShowNotification
                object:nil];
    
    [nc removeObserver:self
                  name:UIKeyboardWillHideNotification
                object:nil];
    
    [nc removeObserver:self
                  name:UITextFieldTextDidChangeNotification
                object:nil];
 
}

- (void)keyboardWasShown:(NSNotification *)notification {
 
    if (self.keyboardHeight != 0) {
        return;
    }

    NSDictionary* info = [notification userInfo];

    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    self.keyboardHeight = keyboardSize.height;

    CGFloat distanceToBottom = self.scrollView.frame.size.height - self.activeField.frame.origin.y - self.activeField.frame.size.height;

    CGFloat collapseSpace = self.keyboardHeight - distanceToBottom;

    if (collapseSpace < 0) {
        return;
    }

    self.willMakeKeyboardOffset = YES;

    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

        self.constraintContentHeight.constant += self.keyboardHeight;

    } completion:^(BOOL finished) {
    }];


    [UIView animateWithDuration:0.3f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{

        self.scrollView.contentOffset = CGPointMake(self.lastOffset.x, collapseSpace + 10);

    } completion:^(BOOL finished) {
    }];
 
}
 
- (void) resetScrollViewOffset {
    
    if (self.willMakeKeyboardOffset) {
        
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            
            self.constraintContentHeight.constant -= self.keyboardHeight;
            self.scrollView.contentOffset = self.lastOffset;
            
        } completion:^(BOOL finished) {
        }];
        
        self.willMakeKeyboardOffset = NO;
                
    }
    
    self.keyboardHeight = 0;
    
}

- (void) textFieldDidChange:(NSNotification *) notification {
    
    UITextField* currentTextField = notification.object;
    
    if (currentTextField.tag != regFormPass) {
        
        UILabel* currentLabel = [self.mapingTextFieldsLabelsDictionary objectForKey:[@(currentTextField.tag) stringValue]];
        currentLabel.text = currentTextField.text;
        
    }
    
}

- (void) keyboardWillBeHidden:(NSNotification *) notification {
    
    [self resetScrollViewOffset];
    
}

- (void) doneWithNumberPad {
    
    [self resetScrollViewOffset];
    [self setFirstRespronderForTextField:self.activeField];
    
}

- (void) setFirstRespronderForTextField:(UITextField*) textField {
    
    NSUInteger textFieldIndex = [self.textFieldsCollection indexOfObject:textField];

    if (textFieldIndex == self.textFieldsCollection.count - 1) {
        
        [textField resignFirstResponder];
        self.activeField = nil;
        
    } else {
        
        self.activeField = [self.textFieldsCollection objectAtIndex:textFieldIndex + 1];
        [self.activeField becomeFirstResponder];
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self resetScrollViewOffset];
    [self setFirstRespronderForTextField:textField];
    
    return YES;

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.activeField = textField;
    
    self.lastOffset = self.scrollView.contentOffset;
    
    return YES;
    
}

@end
