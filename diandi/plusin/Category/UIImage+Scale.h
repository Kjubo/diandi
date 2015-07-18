/**
 * 图片缩放
 * 
 *
 */

@interface UIImage(Scale)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage*)imageScalWithMaxSize:(CGSize)maxSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
@end
