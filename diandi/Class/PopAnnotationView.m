//
//  PopAnnotationView.m
//  diandi
//
//  Created by kjubo on 15/5/28.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "PopAnnotationView.h"

@interface PopAnnotationView ()
@property (nonatomic, strong) UIImageView *ivLocation;  //地标
@property (nonatomic, strong) UIImageView *ivPhoto;     //图片
@end

@implementation PopAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.ivLocation = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_blue"]];
        self.ivLocation.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.ivLocation];
        [self.ivLocation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.ivPhoto = [[UIImageView alloc] init];
        self.ivPhoto.backgroundColor = [UIColor whiteColor];
        self.ivPhoto.layer.masksToBounds = YES;
        [self addSubview:self.ivPhoto];
        [self.ivPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).with.offset(-20);
            make.height.equalTo(self.ivPhoto.mas_width);
            make.top.equalTo(self).with.offset(10);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint photoCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.width * 0.5);
    CGFloat radius = photoCenter.x - 5.0;
    CGContextSetFillColorWithColor(ctx, [self.borderColor CGColor]);
    CGContextAddArc(ctx, photoCenter.x, photoCenter.y, radius, 0, 2*M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    bPath.lineWidth = 0;
    bPath.lineCapStyle = kCGLineCapRound; //线条拐角
    bPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    CGFloat angle = M_PI / 3.0;
    
    [bPath moveToPoint:CGPointMake(photoCenter.x - radius*cos(angle), photoCenter.y + radius*sin(angle))];
    [bPath addQuadCurveToPoint:CGPointMake(photoCenter.x, photoCenter.y * 2.1) controlPoint:CGPointMake(photoCenter.x, photoCenter.y * 2.0)];
    [bPath addQuadCurveToPoint:CGPointMake(photoCenter.x + radius*cos(angle), photoCenter.y + radius*sin(angle)) controlPoint:CGPointMake(photoCenter.x, photoCenter.y * 2.0)];
    [self.borderColor setFill];
    [bPath closePath];
    [bPath fill];
    [bPath stroke];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.ivPhoto.layer.cornerRadius = self.ivPhoto.frame.size.height/2;
}

- (void)setPhotoURL:(NSString *)photoURL{
    if([_photoURL isEqual:photoURL]) return;
    [self.ivPhoto sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:[UIImage imageNamed:kPlaceholderImageName]];
}

@end
