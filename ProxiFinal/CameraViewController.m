
#import "CameraViewController.h"
#import "PostItemDetailViewController.h"
#import "LoginViewController.h"


@interface CameraViewController () <CACameraSessionDelegate>

@property (nonatomic, strong) CameraSessionView *cameraView;
@property (nonatomic,strong) UIImage *captureImage;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self launchCamera];
    
}


- (void)launchCamera{
    
    //Set white status bar
    [self setNeedsStatusBarAppearanceUpdate];

    
    //Instantiate the camera view & assign its frame
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    [self.view addSubview:_cameraView];
    
    //[_cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    [_cameraView hideFlashButton]; //On iPad flash is not present, hence it wont appear.
    [_cameraView hideCameraToogleButton];
    [_cameraView hideDismissButton];
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    
    //Check if User is logged in
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard1 instantiateViewControllerWithIdentifier:@"LoginID"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else{
        
    
    self.captureImage =[self centerCropImage:image];
    PostItemDetailViewController *postItemViewController = [[PostItemDetailViewController alloc]init];
    
    postItemViewController.image = self.captureImage;
        [self presentViewController:postItemViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:postItemViewController animated:YES];
    }

   // [self.cameraView removeFromSuperview];
}

-(void)didCaptureImageWithData:(NSData *)imageData {

    UIImage *image = [[UIImage alloc] initWithData:imageData];
    self.captureImage = image;
    
}

- (UIImage *)centerCropImage:(UIImage *)image
{
    
    /*CGRect squareRect = CGRectMake(offsetX, offsetY, newWidth, newHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], squareRect);
    image = [UIImage imageWithCGImage:imageRef scale:1 orientation:image.imageOrientation];
     */
    // Use smallest side length as crop square length
    CGPoint centerPoint = CGPointMake(image.size.width/2.0, image.size.height/2.0);
    CGFloat squareLength = MIN(image.size.width, image.size.height);
    // Center the crop area
#warning change the width and the height and change the 20 
    CGRect clippedRect = CGRectMake(20, centerPoint.y-squareLength/2, squareLength, squareLength);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);
    return croppedImage;
}

@end
