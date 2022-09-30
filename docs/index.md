--- 
title: "Corpus Phonetics Tutorial"
author: "Eleanor Chodroff"
date: "Updated: 2022-09-30"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
github-repo: echodroff/corpus-phonetics-tutorial
url: 'http\://eleanorchodroff.com/tutorial/'
description: "A corpus phonetics tutorial"
image: "sound.png"
output: pdf_book
#output:
#  bookdown::pdf_book:
#    pandoc_args: [--wrap=none]
urlcolor: blue
---

# Introduction
Corpus phonetics has become an increasingly popular method of research in linguistic analysis. With advances in speech technology and computational power, large scale processing of speech data has become a viable technique. A fair number of researchers have exploited these methods, yet these techniques still remain elusive for many. In the words of Mark Liberman, there has been “surprisingly little change in style and scale of [phonetic] research” from 1966 on, implying that the field still relies on small sample sizes of speech data (2009). While “big data” phonetics is not the be-all and end-all of phonetic research, larger sample sizes ensure more statistically sound conclusions about phonetic values in an individual or population. Furthermore, corpus research is not synonymous with big data. Rather, corpus phonetics describes a method of processing speech data with advantages primarily gained in its computational power (relation to big data) and efficiency. The methods and tools developed for corpus phonetics are based on engineering algorithms primarily from automatic speech recognition (ASR), as well as simple programming for data manipulation. This tutorial aims to bring some of these tools to the non-engineer, and specifically to the speech scientist.
            
Acoustic analysis programs such as [Praat](http://www.fon.hum.uva.nl/praat/){target="_blank"}, [MATLAB](http://www.mathworks.com/products/matlab/){target="_blank"}, and [R](https://www.r-project.org/about.html){target="_blank"} (check out the tuneR and multitaper packages) are already capable of large scale phonetic measurement via their respective scripting languages. While the tutorial covers some phonetic processing in Praat, the primary aim is to introduce supplementary tools to phonetic processing. These tools are based on concepts and algorithms from automatic speech recognition, which allow for automatic alignment of phonetic boundaries to the speech signal.
            
In particular, the tutorial currently covers various tools from the Kaldi Automatic Speech Recognition Toolki, the Montreal Forced Aligner (MFA v2), AutoVOT, and bash shell usage. You can also find additional resources for Praat scripting, additional corpus phonetic tools, and legacy tutorial pages for MFA version 1, FAVE-align, and the Penn Phonetics Lab Forced Aligner in the section on [Other Resources](#other-resources). 

Kaldi is an automatic speech recognition toolkit that provides the infrastructure to build personalized **acoustic models** and **forced alignment** systems. Acoustic models are the statistical representations of each phoneme's acoustic information. The "personalized" component means that this system is capable of modeling any corpus of speech, be it British English, Southern American English, Hungarian, or Korean. It additionally houses many speech processing algorithms, which may be of use to the speech scientist. This tutorial will cover acoustic model training and forced alignment in Kaldi; however, the toolkit as a whole provides exceptional potential for phonetic research. “Forced alignment” is the automatic synchronization of a sequence of phones with an audio file. This process employs **acoustic models** of the sounds of a language, along with a pronunciation lexicon which provides a canonical mapping from orthographic words to sequences of phones. Forced alignment greatly expedites data processing and phonetic measurement. Kaldi and the Montreal Forced Aligner are all capable of forced alignment, but with varying degrees of flexibility with respect to the input speech. Finally, AutoVOT is an automatic voice onset time (VOT) measurement tool that demarcates the burst release and vocalic onset of word-initial, prevocalic stop consonants. 
The tutorial assumes basic familiarity with [Praat](http://www.fon.hum.uva.nl/praat/){target="_blank"}, as well as a Mac operating system, primarily for the default bash/Unix shell in the Terminal application. If using a PC, I recommend downloading [Cygwin](https://www.cygwin.com/){target="_blank"} for running bash/Unix commands, though the Montreal Forced Aligner will also work fine on the downloaded conda console. For AutoVOT and the Penn Forced Aligner, most of the Unix commands are provided in the tutorial itself. While I try to provide as many of the commands as possible, Kaldi requires more fluency in shell scripting. If you have not used the Terminal application before, I recommend looking over some basic Unix commands online (Google or the section on [Bash Shell Basics](#bash-shell-basics)).

If you'd like more info on Corpus Phonetics as I view it, you can check out some slides I've presented on the topic [here](CorpusPhonetics.pdf){target="_blank"}. A brief overview to my quick and dirty approach to Praat scripting can also be found in the slides [here](PraatScripting.pdf){target="_blank"}. 
            
Citations for each of the programs can be found below:

+ Kaldi

Povey, D., Ghoshal, A., Boulianne, G., Burget, L., Glembek, O., Goel, N., Hannemann, M., Motlicek, P., Qian, Y., Schwartz, P., Silovsky, J., Stemmer, G., & Vesely, K. (2011). The Kaldi speech recognition toolkit. In IEEE 2011 Workshop on ASRU.



```r
@INPROCEEDINGS{
         Povey_ASRU2011,
         author = {Povey, Daniel and Ghoshal, Arnab and Boulianne, Gilles and 
           Burget, Lukas and Glembek, Ondrej and Goel, Nagendra and 
           Hannemann, Mirko and Motlicek, Petr and Qian, Yanmin and 
           Schwarz, Petr and Silovsky, Jan and Stemmer, Georg and Vesely, Karel},
       keywords = {ASR, Automatic Speech Recognition, GMM, HTK, SGMM},
          month = dec,
          title = {The Kaldi Speech Recognition Toolkit},
      booktitle = {IEEE 2011 Workshop on Automatic Speech Recognition and Understanding},
           year = {2011},
      publisher = {IEEE Signal Processing Society},
       location = {Hilton Waikoloa Village, Big Island, Hawaii, US},
           note = {IEEE Catalog No.: CFP11SRW-USB},
}
```


+ Montreal Forced Aligner

McAuliffe, Michael, Michaela Socolof, Sarah Mihuc, Michael Wagner, and Morgan Sonderegger (2017). Montreal Forced Aligner [Computer program]. Version 0.9.0, retrieved 17 January 2017 from http://montrealcorpustools.github.io/Montreal-Forced-Aligner/.


+ AutoVOT

Keshet, J., Sonderegger, M., Knowles, T. (2014). AutoVOT: A tool for automatic measurement of voice onset time using discriminative structured prediction [Computer program]. Version 0.91, retrieved August 2014 from https://github.com/mlml/autovot/.

+ This tutorial

Chodroff, E. (2018). Corpus phonetics tutorial. arXiv preprint arXiv:1811.05553. https://arxiv.org/pdf/1811.05553.pdf.
