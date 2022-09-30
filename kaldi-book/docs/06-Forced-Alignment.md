# Forced Alignment

Once acoustic models have been created, Kaldi can also perform forced alignment on audio accompanied by a word-level transcript. Note that the [Montreal Forced Aligner](https://montreal-forced-aligner.readthedocs.io/en/latest/){target="_blank"} is a forced alignment system based on Kaldi-trained acoustic models for several world languages. You could also considering checking out [FAVE](https://github.com/JoFrhwld/FAVE/wiki/FAVE-align){target="_blank"} for aligning American English speech.


Otherwise, if the audio to be aligned is the same as the audio used in the acoustic models, then the alignments can be extracted directly from the alignment files. If you have new audio and transcripts, then the transcript files will need to be updated before alignment.
        
The full procedure will convert output from the model alignment into Praat TextGrids containing the phone-level transcript.

If the data to be aligned is the same as the training data, skip to Section \@ref(extract-alignment). Otherwise, you'll need to update the transcript files and audio file specifications.
            
## Prepare alignment files

To extract alignments for new transcripts and audio, you'll need to create new versions of the files in the directory `data/train`. As a reminder, these files are `text`, `segments`, `wav.scp`, `utt2spk`, and `spk2utt` (see Section \@ref(create-files-for-datatrain)). We'll house these in a new directory in `mycorpus/data`.
            

```r
# create text, segments, wav.scp, utt2spk, and spk2utt

cd mycorpus/data
mkdir alignme         
```
            
## Extract MFCC features
            
Revisit Section \@ref(extract-mfcc-features) on MFCC feature extraction for reference. You'll need to replace `data/train` with the the new directory, `data/alignme`.
            

```r
cd mycorpus
                    
mfccdir=mfcc
for x in data/alignme
do
	steps/make_mfcc.sh --cmd "$train_cmd" --nj 16 $x exp/make_mfcc/$x $mfccdir
	utils/fix_data_dir.sh data/alignme
	steps/compute_cmvn_stats.sh $x exp/make_mfcc/$x $mfccdir
	utils/fix_data_dir.sh data/alignme
done
```
            
## Align data
            
Revisit Section \@ref(triphone-training-and-alignment) on triphone training and alignment for reference. Select the acoustic model and corresponding alignment process you'd like to use. You'll need to replace `data/train` with the the new directory, `data/alignme`. As an example:
            

```r
cd mycorpus
steps/align_si.sh --cmd "$train_cmd" data/alignme data/lang \
exp/tri4a exp/tri4a_alignme || exit 1;
```
                  
## Extract alignment

* **Obtain CTM output from alignment files**

CTM stands for time-marked conversation file and contains a time-aligned phoneme transcription of the utterances. Its format is:

<div id="textfile">
utt_id	channel_num	start_time	phone_dur	phone_id
</div>
            
To obtain these, you will need to decide which acoustic models to use. The following code will extract the CTM output from the alignment files in the directory `tri4a_alignme`, using the acoustic models in `tri4a`:


```r
cd mycorpus
                    
for i in  exp/tri4a_alignme/ali.*.gz;
do src/bin/ali-to-phones --ctm-output exp/tri4a/final.mdl \
ark:"gunzip -c $i|" -> ${i%.gz}.ctm;
done;
```
            
* **Concatenate CTM files**


```r
cd mycorpus/exp/tri4a_alignme
cat *.ctm > merged_alignment.txt
```
            
* **Convert time marks and phone IDs**
            
The CTM output reports start and end times relative to the utterance, as opposed to the file. You will need the `segments` file located in either `data/train` or `data/alignme` to convert the utterance times into file times.
            
The output also reports the phone ID, as opposed to the phone itself. You will need the `phones.txt` file located in `data/lang` to convert the phone IDs into phone symbols.
            
An example script to accomplish this can be downloaded here: [id2phone.R](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/id2phone.R){target="_blank"}
            
After obtaining the `segments` and `phones.txt` files, run `id2phone.R` to convert phone IDs to phones characters and map utterance times to file times. You will need to modify the file locations and possibly the regular expression to obtain the filename from the utterance name. Recall that the CTM output lists the utterance ID whereas the segments file lists the file ID. (If you named things logically, the file ID should be a subset of the utterance ID.)
            
`id2phone.R` returns a modified version of `merged_alignment.txt` called `final_ali.txt`
            
* **Split `final_ali.txt` by file**
            
An example script to accomplish this can be downloaded here: [splitAlignments.py](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/splitAlignments.py){target="_blank"}
            
`final_ali.txt` contains the phone transcript for all files together. This can be split into unique files by running `splitAlignments.py`. You will need to modify the location of `final_ali.txt` in this script.
            

```r
python splitAlignments.py
```
            
* **Create word alignments from phone endings**
            
First we'll need to use the [B I E S] suffixes on the phones in order to group phones together into word-level units.

Run [phons2pron.py](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/phons2pron.py){target="_blank"} to complete this step. Note that I have utf-8 character encoding on this script. If necessary, this can be updated to reflect the character encoding that best matches your files.

Second, we'll need to match the phone pronunciation to the corresponding lexical entry using `lexicon.txt`.

Run [pron2words.py](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/pron2words.py){target="_blank"} to complete this step.
            
## Create Praat TextGrids

* **Append header to each of the text files for Praat**
            
Praat requires that a text file have a header. Once we append the header, then we can convert these text files into TextGrids. The following code requires a text file containing the header:

<div id="textfile">
file_utt	file	id	ali	startinutt	dur	phone	start_utt	end_utt	start	end
</div>

It also requires a `tmp` directory for processing. I put this on my Desktop.


```r
cd ~/Desktop
mkdir tmp
                
header="/Users/Eleanor/Desktop/header.txt"
                
# direct the terminal to the directory with the newly split session files
# ensure that the RegEx below will capture only the session files
# otherwise change this or move the other .txt files to a different folder
                
cd mycorpus/forcedalignment
for i in *.txt;
do
	cat "$header" "$i" > /Users/Eleanor/Desktop/tmp/xx.$$
	mv /Users/Eleanor/Desktop/tmp/xx.$$ "$i"
done;
```

* **Make Praat TextGrids of phone alignments from `.txt` files**
            
[createtextgrid.praat](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/createtextgrid.praat){target="_blank"} will read in the new phone transcripts and corresponding audio files to create a TextGrid for that file. You will need to modify the locations of the phone transcripts and audio files.
            
* **Make Praat TextGrids for word alignments from `word_alignment.txt`**

An example script to accomplish this can be downloaded here: [createWordTextGrids.praat](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/createWordTextGrids.praat){target="_blank"}
            
* **Stack phone and word TextGrids**

[stackTextGrids.praat](https://www.eleanorchodroff.com/tutorial/kaldi/scripts/stackTextGrids.praat){target="_blank"}

