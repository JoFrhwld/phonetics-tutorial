# FAVE-align (Legacy)

## Overview 

**What does FAVE do?** FAVE is up-to-date implementation of the Penn Forced Aligner covered in section \@ref(penn-forced-aligner-legacy). Two programs are included in installation: FAVE-align, which performs forced alignment on American English speech, and FAVE-extract, which performs formant extraction and normalization algorithms. This tutorial focuses on FAVE-align, so future references of FAVE refer to the alignment program only. FAVE takes a sound file and utterance-level transcript (text file) and returns a Praat TextGrid with phone and word alignments. Excellent documentation and instructions for running the aligner can be found on the [FAVE-align website](https://github.com/JoFrhwld/FAVE/wiki/FAVE-align){target="_blank"}. I will cover many of the instructions again, and  try to include some additional tips, but provided installation goes smoothly, this aligner tends to work very well right out of the box. 
        
**What does it include?** As in the Penn Forced Aligner, the system comes with *pre-trained acoustic models* of American English (AE) speech from 25 hours of the SCOTUS corpus, built with the HTK Speech Recognition Toolkit. The section on [Kaldi](https://www.eleanorchodroff.com/tutorial/kaldi/introduction.html){target="_blank"} introduces a similar, but alternative system to HTK, in case you'd like to train your own acoustic models from scratch. In addition to the acoustic models, the download also includes a large lexicon of words based on the CMU Pronouncing Dictionary. The dictionary contains over 100,000 words with their standard pronunciation transcriptions in [Arpabet](http://en.wikipedia.org/wiki/Arpabet){target="_blank"}. Arpabet is a machine-readable phonetic alphabet of General American English with stress marked on the vowels. While I have, perhaps wrongly, used the Penn Forced Aligner to create phonetic alignments for other languages, those transcriptions had to be forced into Arpabet phones. For a quick alignment, this works fine, but please be advised: the acoustic models of the Penn Forced Aligner are trained on American English, so any speech it is given will be treated like American English. Unless manual adjustments follow the automatic alignment, the PFA alignment would not be ideal for most non-AE phonetic analyses. See the Montreal Forced Aligner sections for pre-trained acoustic models of additional languages and [Kaldi](https://www.eleanorchodroff.com/tutorial/kaldi/introduction.html){target="_blank"} if you would like to create custom acoustic models for a particular language or dialect.

## Installation

Please refer to the [FAVE website](https://github.com/JoFrhwld/FAVE/wiki/Installing-FAVE-align){target="_blank"} for installation. As of writing, that page currently includes links to OS-specific downloads for each of the prerequisites.

The prerequisites for FAVE are:

+ HTK Toolkit Version 3.4.1
    + Unlike p2fa, version 3.4.1 **will** work
    + If installing HTK on a Mac, there are additional prerequisites you'll need. Make sure to check out the [FAVE wiki](https://github.com/JoFrhwld/FAVE/wiki/HTK-on-OS-X){target="_blank"} for these instructions.
    
+ Python 2.x
    + Pre-installed on Macs, but you can double-check by opening the terminal and typing python. This will return the version installed. I have been using Version 2.7 and have not had any issues running the aligner. Since you’ve typed python, the terminal is now running with the assumption of python syntax. You want to exit this to get back to its Unix base; to do this, type `exit()` or `quit()`. If you have an earlier version of Python, you may need to type `exit`.
    
+ SoX
    + Download here: [http://sourceforge.net/projects/sox/](http://sourceforge.net/projects/sox/){target="_blank"}
    
To download FAVE, again follow the instructions on the website. FAVE can either be downloaded directly as a .zip or .tar.gz file [here](https://github.com/JoFrhwld/FAVE/releases){target="_blank"} or cloned via git using the following command: 


```r
git clone https://github.com/JoFrhwld/FAVE.git
```
Cloning the system ensures that any new updates are automatically applied to the system. 

## Running the aligner

FAVE requires a wav file and a corresponding transcript that must adhere to a precise format, which is described below. Unlike some other alignment systems, the wav file does not need to have a sampling rate of 16 kHz. During alignment, the system will automatically create a temporary file with this sampling rate.

The text file must be tab-delimited (.txt) with the following five columns:

1. Speaker ID
2. Speaker name
3. Onset time (seconds)
4. Offset time (seconds)
5. Transcription of speech between onset and offset times

Some notes I've taken that could be useful:

+ The speaker ID can be the same as the speaker name

+ You can make up a very large number as a hack for indicating that the offset time should be the end of the file. The aligner will produce a warning, but still complete the alignment. 

+ FAVE sometimes struggles with spontaneous speech, though I imagine any forced alignment system might struggle with this. When the total number of phones in the transcript exceeded the total utterance time under the assumption that a phone is 30 ms, then the aligner produced overlapping intervals. This resulted in areas of Praat TextGrids with overlapping intervals which are visible but no longer functional, and now somewhat useless. It could be a bug in either Praat or FAVE. 

+ Some people have asked me how to align multiple files at once. This can be accomplished with a for loop in the shell script that uses regular expression matching to loop through files. Assuming the transcripts and wav files are in the same folder and differ only in their extension (.txt vs .wav), then you could use the following code (make sure to remove the backslashes and run as one line of code):


```r
# direct shell to location of FAAValign.py script
cd /Users/Eleanor/FAVE/FAVE-align

# loop through transcript files in a second directory that contains 
# the transcript files and like-named wav files
for i in /Users/Eleanor/myCorpus/*.txt; \
do python FAAValign.py "${i/.txt/.wav}" "$i" "${i/.txt/.TextGrid}"; \
done;
```
