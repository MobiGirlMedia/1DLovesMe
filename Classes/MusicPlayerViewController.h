#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface MusicPlayerViewController : UIViewController <MPMediaPickerControllerDelegate> 
{  
    MPMusicPlayerController *musicPlayer;
    UIButton *playPauseButton;
    UILabel *songLabel;
    UILabel *artistLabel;
    UILabel *albumLabel;
    UIImageView *artworkImageView;
    UISlider *volumeSlider;
}

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UILabel *songLabel;
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *albumLabel;
@property (nonatomic, retain) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;

- (IBAction)playOrPauseMusic:(id)sender;
- (IBAction)playNextSong:(id)sender;
- (IBAction)playPreviousSong:(id)sender;
- (IBAction)openMediaPicker:(id)sender;
- (IBAction)volumeSliderChanged:(id)sender;

- (IBAction)close:(id)sender;

@end

