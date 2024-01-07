     /*
    File: AudioRecorder.m
Abstract: The recording class for SpeakHere, which in turn employs 
a recording audio queue object from Audio Queue Services.
 Version: 1.2

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Inc. ("Apple") in consideration of your agreement to the following
terms, and your use, installation, modification or redistribution of
this Apple software constitutes acceptance of these terms.  If you do
not agree with these terms, please do not use, install, modify or
redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may
be used to endorse or promote products derived from the Apple Software
without specific prior written permission from Apple.  Except as
expressly stated in this notice, no other rights or licenses, express or
implied, are granted by Apple herein, including but not limited to any
patent rights that may be infringed by your derivative works or by other
works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/


#include <AudioToolbox/AudioToolbox.h>
#import "AudioQueueObject.h"
#import "AudioRecorder.h"
//#import "AudioViewController.h"
//#import "pocketCalcViewController.h"
#import "pocketCalcViewController.h"


// Audio queue recording callback, which performs recording using Audio File Services.
static void recordingCallback (
	void								*inUserData,
	AudioQueueRef						inAudioQueue,
	AudioQueueBufferRef					inBuffer,
	const AudioTimeStamp				*inStartTime,
	UInt32								inNumPackets,
	const AudioStreamPacketDescription	*inPacketDesc
) {
	// This callback, being outside the implementation block, needs a reference to the 
	//	AudioRecorder object -- which it gets via the inUserData parameter.
	AudioRecorder *recorder = (AudioRecorder *) inUserData;
		
	// if there is audio data, write it to the file
	if (inNumPackets > 0) {

		AudioFileWritePackets (
			recorder.audioFileID,
			FALSE,
			inBuffer->mAudioDataByteSize,
			inPacketDesc,
			recorder.startingPacketNumber,
			&inNumPackets,
			inBuffer->mAudioData
		);
		
		[recorder incrementStartingPacketNumberBy:  (UInt32) inNumPackets];
	}

	// if not stopping, re-enqueue the buffer so that it can be filled again
	if (recorder.isRunning) {

		AudioQueueEnqueueBuffer (
			inAudioQueue,
			inBuffer,
			0,
			NULL
		);
	}
}

// Audio queue poperty callback function, called when an audio queue property changes. The  
//	only Audio Queue Services property as of Mac OS X v10.5.3 is 
//	kAudioQueueProperty_IsRunning.
static void audioQueuePropertyListenerCallback (
	void					*inUserData,
	AudioQueueRef			queueObject,
	AudioQueuePropertyID	propertyID
) {
	AudioRecorder *recorder = (AudioRecorder *) inUserData;

	if (recorder.stopping) {
	
		// A codec may update its cookie at the end of an encoding session, so reapply it to the file now.
		// Linear PCM, as used in this app, doesn't have magic cookies. This is included in case you
		// want to change to a format that does use magic cookies.
		[recorder copyEncoderMagicCookieToFile: recorder.audioFileID fromQueue: recorder.queueObject];

		AudioFileClose (recorder.audioFileID);
	}

	[recorder.notificationDelegate updateUserInterfaceOnAudioQueueStateChange: recorder];
}


@implementation AudioRecorder

@synthesize stopping;

- (id) initWithURL: fileURL {
	NSLog (@"initializing a recorder object.");
	self = [super init];

	if (self != nil) {

		// Specify the recording format. Options are:
		//
		//		kAudioFormatLinearPCM
		//		kAudioFormatAppleLossless
		//		kAudioFormatAppleIMA4
		//		kAudioFormatiLBC
		//		kAudioFormatULaw
		//		kAudioFormatALaw
		//
		// When targeting the Simulator, SpeakHere uses linear PCM regardless of the format
		//	specified here. See the setupAudioFormat: method in this file.
		
		//[self setupAudioFormat: kAudioFormatLinearPCM];
		[self setupAudioFormat: kAudioFormatLinearPCM];
		
		OSStatus result =	AudioQueueNewInput (
								&audioFormat,
								recordingCallback,
								self,					// userData
								NULL,					// run loop
								NULL,					// run loop mode
								0,						// flags
								&queueObject
							);

		NSLog (@"Attempted to create new recording audio queue object. Result: %ld", result);

		// get the recording format back from the audio queue's audio converter --
		//	the file may require a more specific stream description than was 
		//	necessary to create the encoder.
		UInt32 sizeOfRecordingFormatASBDStruct = sizeof (audioFormat);
		
		AudioQueueGetProperty (
			queueObject,
			kAudioQueueProperty_StreamDescription,	// this constant is only available in iPhone OS
			&audioFormat,
			&sizeOfRecordingFormatASBDStruct
		);
		
		AudioQueueAddPropertyListener (
			[self queueObject],
			kAudioQueueProperty_IsRunning,
			audioQueuePropertyListenerCallback,
			self
		);

		[self setAudioFileURL: (CFURLRef) fileURL];
		
		[self enableLevelMetering];
	}
	return self;
} 


- (void) copyEncoderMagicCookieToFile: (AudioFileID) theFile fromQueue: (AudioQueueRef) theQueue {

	OSStatus	result;
	UInt32		propertySize;
	
	// get the magic cookie, if any, from the converter		
	result =	AudioQueueGetPropertySize (
					theQueue,
					kAudioQueueProperty_MagicCookie,
					&propertySize
				);
	
	if (result == noErr && propertySize > 0) {
		// there is valid cookie data to be fetched;  get it
		Byte *magicCookie = (Byte *) malloc (propertySize);
		
		AudioQueueGetProperty (
			theQueue,
			kAudioQueueProperty_MagicCookie,
			magicCookie,
			&propertySize
		);
				
		// now set the magic cookie on the output file
		AudioFileSetProperty (
			theFile,
			kAudioFilePropertyMagicCookieData,
			propertySize,
			magicCookie
		);
				
		free (magicCookie);
	}
}


- (void) record {

	[self setupRecording];

	AudioQueueStart (
		queueObject,
		NULL			// start time. NULL means as soon as possible.
	);
}


- (void) stop {

	AudioQueueStop (
		queueObject,
		TRUE			// stop immediately.
	);
}

// Configures the audio data format for recording
- (void) setupAudioFormat: (UInt32) formatID {

	// Obtains the hardware sample rate for use in the recording
	// audio format. Each time the audio route changes, the sample rate
	// needs to get updated.
	UInt32 propertySize = sizeof (self.hardwareSampleRate);
	
	AudioSessionGetProperty (
		kAudioSessionProperty_CurrentHardwareSampleRate,
		&propertySize,
		&hardwareSampleRate
	);
	
// When running in the Simulator, the kAudioSessionProperty_CurrentHardwareSampleRate
//	property is not available, so set it manually.
#if TARGET_IPHONE_SIMULATOR
		//audioFormat.mSampleRate = 44100.0;
	audioFormat.mSampleRate = 8000.0;
#warning *** Simulator mode: using 44.1 kHz sample rate.
#else
		audioFormat.mSampleRate = self.hardwareSampleRate;
	audioFormat.mSampleRate = 8000.0;
#endif

	NSLog (@"Hardware sample rate = %f", self.audioFormat.mSampleRate);

	audioFormat.mFormatID			= formatID;
	audioFormat.mChannelsPerFrame	= 1;
	
	if (formatID == kAudioFormatLinearPCM) {
	
		audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
		audioFormat.mFramesPerPacket	= 1;
		audioFormat.mBitsPerChannel		= 16;
		audioFormat.mBytesPerPacket		= 2;
		audioFormat.mBytesPerFrame		= 2;
	}
}


- (void) setupRecording {

	self.startingPacketNumber = 0;

	if (!self.audioFileID) {
		// create the audio file
		AudioFileCreateWithURL (
			audioFileURL,
			kAudioFileCAFType,
			&audioFormat,
			kAudioFileFlags_EraseFile,
			&audioFileID
		);		
	}

	// copy the cookie first to give the file object as much info as possible about the data going in
	[self copyEncoderMagicCookieToFile: audioFileID fromQueue: queueObject];

	// allocate and enqueue buffers
	int bufferByteSize = 65536;		// this is the maximum buffer size used by the player class
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < kNumberAudioDataBuffers; ++bufferIndex) {
	
		AudioQueueBufferRef buffer;
		
		AudioQueueAllocateBuffer (
			queueObject,
			bufferByteSize, &buffer
		);

		AudioQueueEnqueueBuffer (
			queueObject,
			buffer,
			0,
			NULL
		);
	}
}


- (void) dealloc {

	AudioQueueDispose (
		queueObject,
		TRUE
	);
	
	[super dealloc];
}

@end
