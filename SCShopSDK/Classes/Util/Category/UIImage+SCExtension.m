//
//  UIImage+SCExtension.m
//  shopping
//
//  Created by gejunyu on 2020/7/3.
//  Copyright © 2020 jsmcc. All rights reserved.
//

#import "UIImage+SCExtension.h"


@implementation UIImage (SCExtension)

+ (nullable UIImage *)bundleImageNamed:(NSString *)name
{
    return [self bundleImageNamed:name scale:2 type:@"png"];
}

+ (nullable UIImage *)bundleImageNamed:(NSString *)name scale:(NSInteger)scale
{
    return [self bundleImageNamed:name scale:scale type:@"png"];
}

+ (nullable UIImage *)bundleImageNamed:(NSString *)name type:(NSString *)type
{
    return [self bundleImageNamed:name scale:2 type:type];
}

+ (nullable UIImage *)bundleImageNamed:(NSString *)name scale:(NSInteger)scale type:(NSString *)type
{
    //开发
//    NSBundle *frameworkBundle = [NSBundle bundleForClass:SCUtilities.class];
    //打包
    NSBundle *frameworkBundle = [NSBundle mainBundle];

    NSURL *bundleUrl = [frameworkBundle.resourceURL URLByAppendingPathComponent:@"SCShopResource.bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleUrl];
    if (resourceBundle) {
        NSString *scaleStr = scale <= 1 ? @"" : [NSString stringWithFormat:@"@%lix",scale];
        NSString *typeStr = VALID_STRING(type) ? type : @"png";
        NSString *imageName = [NSString stringWithFormat:@"%@%@.%@",name,scaleStr,typeStr];
        UIImage *image = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:imageName ofType:nil]];
        return image;
    }
    
    return [UIImage imageNamed:name];
    
}


-(UIImage *)thumbWithSize:(CGSize)size{
    
    CGSize originalsize = self.size;
    CGSize targetSize = CGSizeZero;
    
    if (!size.width || !size.height) {
        if (self.size.width>self.size.height) {
            targetSize = CGSizeMake(self.size.height, self.size.height);
        }else{
            targetSize = CGSizeMake(self.size.width, self.size.width);
        }
    }else{
        targetSize = size;
    }
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<targetSize.width && originalsize.height<targetSize.height)
    {
        return self;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>targetSize.width && originalsize.height>targetSize.height)
    {
        CGFloat rate = 1.0;
        
        CGFloat widthRate = originalsize.width/targetSize.width;
        
        CGFloat heightRate = originalsize.height/targetSize.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, originalsize.height/2-targetSize.height*rate/2, originalsize.width, targetSize.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(originalsize.width/2-targetSize.width*rate/2, 0, targetSize.width*rate, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(targetSize);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, targetSize.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, targetSize.width, targetSize.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        return standardImage;
        
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>targetSize.height || originalsize.width>targetSize.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>targetSize.height)
        {
            NSLog(@"比例 ： height > width");
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, originalsize.height/2-targetSize.height/2, originalsize.width, targetSize.height));//获取图片整体部分
        }
        
        else if (originalsize.width>targetSize.width)
        {
            NSLog(@"比例 ： height < width");
            imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(originalsize.width/2-targetSize.width/2, 0, targetSize.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(targetSize);//指定要绘画图片的大小
        
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, targetSize.height);
        
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, targetSize.width, targetSize.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        NSLog(@"比例 ： height = width");
        return self;
    }
}


- (CGContextRef)createARGBBitmapContext {
    
    // Get image width, height
    size_t pixelsWide = CGImageGetWidth(self.CGImage);
    size_t pixelsHigh = CGImageGetHeight(self.CGImage);
    
    // Declare the number of bytes per row
    NSInteger bitmapBytesPerRow  = (pixelsWide * 4);
    NSInteger bitmapByteCount    = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data
    void *bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    
    // Create the bitmap context
    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                  pixelsWide,
                                                  pixelsHigh,
                                                  8,      // bits per component
                                                  bitmapBytesPerRow,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    return context;
}

- (UIColor *)getPixelColorAtPoint:(CGPoint)point
{
    UIColor* color = nil;
    CGImageRef inImage = self.CGImage;
    // Create bitmap context to draw the image into
    CGContextRef cgctx = [self createARGBBitmapContext];
    if (cgctx == NULL) {
        return nil; /* error */
    }

    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context
    CGContextDrawImage(cgctx, rect, inImage);
    
    // get image data
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        //NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    //release the context
    CGContextRelease(cgctx);
    // Free image data
    if (data) {
        free(data);
    }
    return color;
}

@end
