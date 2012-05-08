iClassic
========

iPod Classic iPhone App

Notes:
1) AVAsset documentation is poor.  Attempted to access how long the song has 
currently been played with the following code:

    NSURL *url = [nowPlayingItem valueForProperty:MPMediaItemPropertyAssetURL];
    AVAsset *asset = [AVAsset assetWithURL:url];
    CMTime duration = asset.duration;
    float timePlayed = CMTimeGetSeconds(duration);

This however returns the length of the entire song.

2) Custom View connected in the story board triggers

	- (void)awakeFromNib
	
	but does not trigger
	
	- (id)initWithFrame:(CGRect)frame
	
	
