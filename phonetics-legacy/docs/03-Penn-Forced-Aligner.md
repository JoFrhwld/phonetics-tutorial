# Penn Forced Aligner (Legacy) 

## Overview 

**What does the Penn Forced Aligner do?** The Penn Forced Aligner takes a sound file and the corresponding transcript of speech and returns a Praat TextGrid with phone and word alignments. You can find the website [here](https://www.ling.upenn.edu/phonetics/old_website_2015/p2fa/){target="_blank"}.
        
**What does it include?** The system comes with *pre-trained acoustic models* of American English (AE) speech from the SCOTUS corpus, built with the HTK Speech Recognition Toolkit. The section on [Kaldi](https://www.eleanorchodroff.com/tutorial/kaldi/introduction.html) introduces a similar, but alternative system to HTK, in case you'd like to train your own acoustic models from scratch. In addition to the acoustic models, the download also includes a large lexicon of words based on the CMU Pronouncing Dictionary. The dictionary contains over 100,000 words with their standard pronunciation transcriptions in [Arpabet](http://en.wikipedia.org/wiki/Arpabet){target="_blank"}. Arpabet is a machine-readable phonetic alphabet of General American English with stress marked on the vowels. While I have, perhaps wrongly, used the Penn Forced Aligner to create phonetic alignments for other languages, those transcriptions had to be forced into Arpabet phones. For a quick alignment, this works fine, but please be advised: the acoustic models of the Penn Forced Aligner are trained on American English, so any speech it is given will be treated like American English. Unless manual adjustments follow the automatic alignment, the PFA alignment would not be ideal for most non-AE phonetic analyses. Again, see the section on [Kaldi](https://www.eleanorchodroff.com/tutorial/kaldi/introduction.html) if you would like to create acoustic models for a different language or dialect.

## Prerequisites 

* HTK Toolkit Version 3.4
    + Version 3.4.1 will **not** work
    + Download here: [http://htk.eng.cam.ac.uk/](http://htk.eng.cam.ac.uk/){target="_blank"}
    + Many run into issues installing this, but detailed installation instructions (and additional tutorial notes) can be found [here](http://linguisticmystic.com/2014/02/12/penn-forced-aligner-on-mac-os-x/){target="_blank"}. **Update** as of November 11, 2018: this website (linguisticmystic.com) no longer works, but covered how to install the Penn Forced Aligner on a Mac. The Penn Forced Aligner is no longer being maintained, and has instead been replaced by FAVE (section \@ref(fave-align-legacy)). The corresponding prerequisites for HTK installation on Mac are now covered on the [FAVE wiki](https://github.com/JoFrhwld/FAVE/wiki/HTK-on-OS-X){target="_blank"}).
    
* Python 2.5 or 2.6
    + Pre-installed on Macs, but you can double-check by opening the terminal and typing python. This will return the version installed. I have been using Version 2.7.6 and have not had any issues running the aligner. Since you’ve typed python, the terminal is now running with the assumption of python syntax. You want to exit this to get back to its Unix base; to do this, type `exit()` or `quit()`. If you have an earlier version of Python, you may need to type `exit`.
    
* SoX
    + Download here: [http://sourceforge.net/projects/sox/](http://sourceforge.net/projects/sox/){target="_blank"}
            
## Modifying the lexicon 

After downloading the Penn Forced Aligner, you should now have a directory named `p2fa`. Before beginning any of the following steps, take note of the parent directory and path, as you will need to direct your terminal to the exact `p2fa` location. For example, my `p2fa` directory is located in `/Users/Eleanor`. I can direct my terminal now to that location and view the contents of that directory by typing the following:


```r
cd /Users/Eleanor/
ls
```

Once you've located the `p2fa` directory, you can find the lexicon in `p2fa/model/dict`.
                    
Despite the lack of a `.txt` extension, `dict` is a text file, making it quite easy to add words and non-words alike. You’ll want to make sure that all words in your transcript are indeed in the dictionary. This can be done by converting your transcript into a word list and comparing it against the dictionary.
            
First, you'll need a copy of your transcript in a text file called `fulltranscript.txt`. (Actually, you can call it whatever you want; just make sure to change the name in the code!)
            
In the terminal, navigate to the location of your transcript and then we can use the long code to create a list of all unique words in the transcript. My `fulltranscript.txt` is located in `/Users/Eleanor/myCorpus`. You'll need to change that part to match your file location.


```r
cd /Users/Eleanor/myCorpus
tr ' ' '\n' < fulltranscript.txt | tr '[a-z]' '[A-Z]' | \
sed '/^$/d' | sed '/[.,?!;:]/d' | sort | uniq -c | sed 's/^ *//' | \
sort -r -n > fulltranscript_words.txt
```
The above clearly does a whole slew of functions. It will first take your transcript, separate each word with a new line (`tr ' ' '\n' < fulltranscript.txt`), capitalize all letters (`tr '[a-z]' '[A-Z]'`), delete blank lines (`sed '/^$/d'`), remove punctuation (`sed '/[.,?!;:]/d'`), sort the words (`sort`), remove duplicate words (`uniq -c`), delete blank lines/trailing white space again (`sed 's/^ *//'`), sort again and give you a count of how many times each word appears in the transcript (`sort -r -n > fulltranscript_words.txt`).
            
The following code will find the word pronunciations in the CMU dictionary. This is accomplished by taking the words and putting them into the regular expression format for locating the beginning of a line (`^`). This results in `tmp.txt`. That file is then compared against the CMU dictionary. If the word is in the dictionary, then the dictionary line is extracted such that you have both the word and its pronunciation. Note that when using the `cut` command, the default cut is tab (`cut -f 2`), but if the delimiter is anything other than tab (space, comma, etc.), it can be specified with `cut -d 'my delimiter' -f 2 myfile.txt`.


```r
cut -d ' ' -f 2 fulltranscript_**words**.txt | sed 's/^/^/' | sed 's/$/  /' > tmp.txt
egrep --file=tmp.txt /Users/Eleanor/p2fa/model/dict > fulltranscript_words_pron.txt;
```

You then need to determine which words were skipped in this process, i.e., the words missing from the CMU dictionary. This can be done by comparing the final `fulltranscript_words_pron.txt` against the original `fulltranscript_words.txt`.


```r
# extracts and sorts relevant columns and stores in tmp file
sort -k 2 fulltranscript_words.txt > tmp1.txt
sort -k 1 fulltranscript_words_pron.txt > tmp2.txt
                    
# merges the two files to list words, word count, and pron
join -1 2 -2 1 tmp1.txt tmp2.txt > fulltranscript_words_pron2.txt
                    
# lists words with missing pronunciations
# these are the words you need to add to the dictionary
join -v 1 -1 2 -2 1 tmp1.txt tmp2.txt > fulltranscript_words_missing_pron.txt
```


```r
# Extras:
# get count of word types
wc -l < fulltranscript_words.txt
                        
# get count of phone types
wc -l < fulltranscript_words_pron.txt
                        
# get count of phone tokens
cut -d' ' -f 3- < fulltranscript_words_pron.txt | tr ' ' '\n' | sort | uniq -c | \
sed 's/^ *//' | sort -r -n > fulltranscript_phones.txt
```

Lexical entries need to be added in the same format as the rest of the dictionary, which is the word in all caps followed by two spaces and the CMU pronunciation with stress on the vowel. For example:

<div id="textfile">
KLATT  K L AE1 T
ELEANOR  EH1 L AH0 N AO2 R
ELEANOR  EH1 L AH0 N ER2
</div>

Multiple pronunciation variants are fine (this can even be used to test some interesting hypotheses). CMU provides a nice tool for converting standard spellings of words and non-words into the correct pronunciation. This can be found here: [http://www.speech.cs.cmu.edu/tools/lextool.html](http://www.speech.cs.cmu.edu/tools/lextool.html){target="_blank"}.

After running this tool, you will need to add the stress value to the vowels (1 = primary, 0 = unstressed, 2 = secondary). You can always refer to similar words in the dictionary for an example.

## Running the aligner 

The standard implementation of the Penn Forced Aligner will process a single wav file and transcript, returning the phone and word alignment on a Praat TextGrid.

Before beginning this part of the tutorial, make sure that all the words in your transcript are in the included lexicon, `p2fa/model/dict`. If you're not sure or know that they are not, please visit Section \@ref(modifying-the-lexicon).

Ingredients:  
* Wav file of recording  
* Corresponding transcript. Example below:  
<div id="textfile">
SAY TUTT AGAIN

SAY PAT AGAIN

SAY DOT AGAIN

</div>

The transcript should contain the words with spaces between them; these are standardly capitalized, but the aligner will accept lowercase and uppercase letters. Line breaks are fine, as are apostrophes, as long as that spelling is in the dictionary. All punctuation should be removed. Others have suggested adding an “`sp`” or space between words and sentences. This is not necessary. The aligner will determiner whether or not a small space or silence is present.
                
An important note is that the aligner can derail if there is untranscribed noise or speech in the recording. In my experience, it’s not too bad at recovering after a short while, but it’s best to avoid that situation. This can be accomplished by giving it smaller portions of the wav file, or ensuring that all noise and extraneous speech is explicitly transcribed. Smaller portions of the wav file can be created manually by extracting the relevant clip(s). Alternatively, a modified version of the script can process relevant sections of speech defined by their start and end times. Yet another option is to transcribe noise as `{NS}` and silence as `{SP}`. I have not tried this method, so I do not know how robust it is to extraneous speech.
                
To process a single wav file and transcript, direct the terminal to the directory containing the Penn Forced Aligner `align.py` script with `cd`, then type the second command. The arguments to the align.py script are the locations of the wav file and transcript file. The script creates the aligned TextGrid as output (`subj01.TextGrid`, but you can call it whatever you want).


```r
cd ~/p2fa
python align.py /Users/Eleanor/myCorpus/subj01.wav \
/Users/Eleanor/myCorpus/subj01.txt subj01.TextGrid
```

And that's it!
