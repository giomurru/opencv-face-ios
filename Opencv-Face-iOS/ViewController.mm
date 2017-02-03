#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/objdetect.hpp>

#import "ViewController.h"

using namespace cv;

@interface ViewController () <CvVideoCameraDelegate>
@property (nonatomic, strong) UIImageView *cameraView;
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@end

@implementation ViewController
{
    CascadeClassifier _cascade;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 352)];
    self.cameraView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    [self.view addSubview:self.cameraView];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.cameraView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    
    NSString *xmlPath = [[NSBundle mainBundle ] pathForResource:@"haarcascade_frontalface_default"
                                                         ofType: @"xml"];
    NSLog(@"%@", xmlPath);
    _cascade.load([xmlPath cStringUsingEncoding:NSUTF8StringEncoding]);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.videoCamera start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processImage:(cv::Mat &)image
{
    CFTimeInterval t1 = CACurrentMediaTime();
    
    cvSetErrMode( CV_ErrModeParent );

    std::vector<cv::Rect> faces;
    _cascade.detectMultiScale( image, faces, 1.2, 2, 0 | cv::CASCADE_SCALE_IMAGE, cv::Size(30, 30) );

    //    faces   = cvHaarDetectObjects( &tmp_image, _cascade, storage, ( float )1.2, 2, CV_HAAR_DO_CANNY_PRUNING, cvSize( 20, 20 ) );

    if (faces.size() > 0)
    {
        for(int i = 0; i < faces.size(); i++ )
        {
            cv::Rect rect = faces[i];
            rectangle(image, cv::Point(rect.x, rect.y), cv::Point(rect.x+rect.width, rect.y+rect.height), Scalar(0,255,0,255), 4);
        }
    }
    
    CFTimeInterval deltaTime = CACurrentMediaTime() - t1;
    NSLog(@"delta time %.0fms", deltaTime*1000);
}

- (void)dealloc
{
    //cvReleaseHaarClassifierCascade( &_cascade);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
