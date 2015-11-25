
 /*
  SourceCode From GITHUB
  */

#import <UIKit/UIKit.h>

@class JAMValidatingTextField;

/** TextField status modes. */
typedef NS_ENUM(NSInteger, JAMValidatingTextFieldStatus) {
    JAMValidatingTextFieldStatusIndeterminate = -1,
    JAMValidatingTextFieldStatusInvalid,
    JAMValidatingTextFieldStatusValid
};

/** TextField types. */
typedef NS_ENUM(NSUInteger, JAMValidatingTextFieldType) {
    JAMValidatingTextFieldTypeNone,
    JAMValidatingTextFieldTypeEmail,
    JAMValidatingTextFieldTypeURL,
    JAMValidatingTextFieldTypePhone,
    JAMValidatingTextFieldTypeZIP
};

/** The delegate is used for validation if it is assigned. */
@protocol JAMValidatingTextFieldValidationDelegate <NSObject>
@optional
-(JAMValidatingTextFieldStatus)textFieldStatus:(JAMValidatingTextField *)textField;
@end

/** JAMValidatingTextField is a class that extends UITextField and adds validation facilities including validation types and visual feedback.
 
 You can either set a type (email, URL, phone, zip, etc.) or set a property to validate via block, NSRegularExpression, or delegate.
 
 The text field will provide visual feedback indicating wheter it's in a valid, invalid, or indeterminate state.
 */
@interface JAMValidatingTextField : UITextField

/** Use this to get the validation status of your text field. */
@property (nonatomic, readonly) JAMValidatingTextFieldStatus validationStatus;

/** Use this property to easily set a validation type for your text field. */
@property (nonatomic) JAMValidatingTextFieldType validationType;

/** Normally, an empty text field is considered "indeterminate." Setting isRequired to YES will cause the textfield to be considered invalid even when it is empty. */
@property (nonatomic, getter = isRequired) BOOL required;

/** The color of the indeterminate indicator, default is 75% white. */
@property (nonatomic) UIColor *indeterminateColor;
/** The color of the invalid indicator, default is kind of red. */
@property (nonatomic) UIColor *invalidColor;
/** The color of the invalid indicator, default is kind of green. */
@property (nonatomic) UIColor *validColor;

/** @warning Validation methods (block, Regex, or delegate) and the built-in types are all mutally exclusive, that is, setting any one will clear out the others. */
/** Sets the validation mechanism to be a block.
 @param validationBlock the block to use to validate the text field.
 */
@property (nonatomic, copy) JAMValidatingTextFieldStatus (^validationBlock)(void);

/** Sets the validation mechanism to be an NSRegularExpression. One or more matches will indicate a valid condition.
 @param validationRegularExpression the regular expression to use.
 */
@property (nonatomic) NSRegularExpression *validationRegularExpression;

/** Sets the validation mechanism to be a JAMValidatingTextFieldValidationDelegate. */
@property (nonatomic, weak) id <JAMValidatingTextFieldValidationDelegate> validationDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
-(instancetype)init;
@end
