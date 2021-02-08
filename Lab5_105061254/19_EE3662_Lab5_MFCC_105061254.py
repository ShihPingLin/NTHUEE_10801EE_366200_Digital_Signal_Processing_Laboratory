# -*- coding: utf-8 -*-
"""
Created on Mon Oct 7 2019

@author: Cosine
"""

import numpy as np
import math
from scipy.fftpack import dct 
import matplotlib.pyplot as plt
import soundfile as sf
from scipy.fftpack import fft, ifft

def pre_emphasis(signal,coefficient=0.95):
    return np.append(signal[0],signal[1:]-coefficient*signal[:-1])

def mel2hz(mel):
    '''
    mel scale to Hz scale
    '''
    hz = 700 * (10**(mel/2595) - 1)
    return hz

def hz2mel(hz):
    '''
    hz scale to mel scale
    '''
    mel = 2595 * np.log10(1 + hz / 700)
    return mel

def get_filter_banks(filters_num,NFFT,samplerate,low_freq=0,high_freq=None):
    ''' Mel Bank
    filers_num: filter numbers
    NFFT:points of your FFT
    samplerate:sample rate
    low_freq: the lowest frequency that mel frequency include
    high_freq:the Highest frequency that mel frequency include
    '''
    #turn the hz scale into mel scale
    low_mel=hz2mel(low_freq)
    high_mel=hz2mel(high_freq)
    #in the mel scale, you should put the position of your filter number 
    mel_points=np.linspace(low_mel,high_mel,filters_num+2)
    #get back the hzscale of your filter position
    hz_points=mel2hz(mel_points)
    #Mel triangle bank design
    bin=np.floor((NFFT+1)*hz_points/samplerate)
    fbank=np.zeros([filters_num,int(NFFT/2+1)])
    for j in range(0, filters_num):
        for i in range(int(bin[j]), int(bin[j+1])):
            fbank[j, i] = (i - bin[j])/(bin[j+1] - bin[j])
        for i in range(int(bin[j+1]), int(bin[j+2])):
            fbank[j, i] = (bin[j+2] - i)/(bin[j+2] - bin[j+1])
    return fbank

signal,fs = sf.read('SteveJobs.wav')

signal = signal[514:]

t = np.arange(0, len(signal))*(1.0/fs) 
plt.figure(1) 
plt.plot(t, signal)
plt.ylim(-0.8, 0.8)
plt.show 


fs=fs                               #SampleRate
signal_length=len(signal)           #Signal length
win_length=0.01                        #Window_size(sec)
win_step=0.005                          #Window_hop(sec)
frame_length=int(win_length*fs)     #Frame length(samples)
frame_step=int(win_step*fs)         #Step length(samples)
emphasis_coeff=0.95                    #pre-emphasis para
filters_num=20                       #Filter number
'''
    NFFT:points of your FFT
    low_freq: the lowest frequency that mel frequency include
    high_freq:the Highest frequency that mel frequency include
'''
NFFT=512
low_freq=0
high_freq=int(fs/2)

signal=pre_emphasis(signal)
sf.write('SteveJobs_out.wav', signal, fs)

t = np.arange(0, len(signal))*(1.0/fs) 
plt.figure(2) 
plt.plot(t, signal)
plt.ylim(-0.8, 0.8)
plt.show 

frames_num=1+int(math.ceil((1.0*signal_length-frame_length)/frame_step))

#padding    
pad_length=int((frames_num-1)*frame_step+frame_length)  
zeros=np.zeros((pad_length-signal_length,))          
pad_signal=np.concatenate((signal,zeros))   

         
#split into frames
indices=np.tile(np.arange(0,frame_length),(frames_num,1))+np.tile(np.arange(0,frames_num*frame_step,frame_step),(frame_length,1)).T  
indices=np.array(indices,dtype=np.int32) 
frames=pad_signal[indices] 
frames *= np.hamming(frame_length)


complex_spectrum=np.fft.rfft(frames,NFFT).T
absolute_complex_spectrum=np.abs(complex_spectrum)


fb=get_filter_banks(filters_num,NFFT,fs,low_freq,high_freq)  


filter_banks = np.dot(absolute_complex_spectrum.T, fb.T)
filter_banks = np.where(filter_banks == 0, np.finfo(float).eps, filter_banks)
feat = 10 * np.log10(filter_banks)

feat=dct(feat, norm='ortho')[:,:filters_num]


#Print triangular band-pass filter
xaxis = np.arange(0, len(fb[0]))*(1.0*fs/len(fb)) 
plt.figure(3) 
for i in range(len(fb)):
    plt.plot(xaxis,fb[i])
plt.show 

#Print MFCC
plt.figure(4) 
for i in range(1, len(feat)):
    plt.plot(feat[i]) 
plt.show




