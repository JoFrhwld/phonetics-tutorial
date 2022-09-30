# Training Overview

Before diving into the scripts, it is essential to understand the basic procedure for training acoustic models. Given the audience and purpose of the tutorial, this section will focus on the process as opposed to the computation (see [Jurafsky and Martin 2008](http://www.amazon.com/Speech-Language-Processing-Daniel-Jurafsky/dp/0131873210/ref=sr_1_1?s=books&ie=UTF8&qid=1435870892&sr=1-1&keywords=speech+and+language+processing&pebp=1435870888175&perid=0HS6VNBZX7NEZN1NTCX2){target="_blank"}, [Young 1996](https://ieeexplore.ieee.org/abstract/document/536824/){target="_blank"}, among many others). The procedure can be laid out as follows:  
            
**1. Obtain a written transcript of the speech data**
            
For a more precise alignment, utterance (~sentence) level start and end times are helpful, but not necessary.  

**2. Format transcripts for Kaldi**
            
Kaldi requires various formats of the transcripts for acoustic model training. You'll need the start and end times of each utterance, the speaker ID of each utterance, and a list of all words and phonemes present in the transcript.

**3. Extract acoustic features from the audio**
            
Mel Frequency Cepstral Coefficients (MFCC) are the most commonly used features, but Perceptual Linear Prediction (PLP) features and other features are also an option. These features serve as the basis for the acoustic models.<br>

**4. Train monophone models**
            
A monophone model is an acoustic model that does not include any contextual information about the preceding or following phone. It is used as a building block for the triphone models, which do make use of contextual information.
            
*Note: from this point forward, we will be assuming a Gaussian Mixture Model/Hidden Markov Model (GMM/HMM) framework. This is in contrast to a deep neural network (DNN) system.
            
**5. Align audio with the acoustic models**  
            
The parameters of the acoustic model are estimated in acoustic training steps; however, the process can be better optimized by cycling through training and alignment phases. This is also known as Viterbi training (related, but more computationally expensive procedures include the Forward-Backward algorithm and Expectation Maximization). By aligning the audio to the reference transcript with the most current acoustic model, additional training algorithms can then use this output to improve or refine the parameters of the model. Therefore, each training step will be followed by an alignment step where the audio and text can be realigned.  
            
**6. Train triphone models**  
            
While monophone models simply represent the acoustic parameters of a single phoneme, we know that phonemes will vary considerably depending on their particular context. The triphone models represent a phoneme variant in the context of two other (left and right) phonemes.  
           
At this point, we'll also need to deal with the fact that not all triphone units are present (or will ever be present) in the dataset. There are (# of phonemes)^3^ possible triphone models, but only a subset of those will actually occur in the data. Furthermore, the unit must also occur multiple times in the data to gather sufficient statistics for the data. A phonetic decision tree groups these triphones into a smaller amount of acoustically distinct units, thereby reducing the number of parameters and making the problem computationally feasible.  

**7. Re-align audio with the acoustic models &amp; re-train triphone models**
            
Repeat steps 5 and 6 with additional triphone training algorithms for more refined models. These typically include delta+delta-delta training, LDA-MLLT, and SAT. The alignment algorithms include speaker independent alignments and FMLLR.
            
* **Training Algorithms**  

**Delta+delta-delta training** computes delta and double-delta features, or dynamic coefficients, to supplement the MFCC features. Delta and delta-delta features are numerical estimates of the first and second order derivatives of the signal (features). As such, the computation is usually performed on a larger window of feature vectors. While a window of two feature vectors would probably work, it would be a very crude approximation (similar to how a delta-difference is a very crude approximation of the derivative). Delta features are computed on the window of the original features; the delta-delta are then computed on the window of the delta-features.
            
**LDA-MLLT** stands for Linear Discriminant Analysis – Maximum Likelihood Linear Transform. The Linear Discriminant Analysis takes the feature vectors and builds HMM states, but with a reduced feature space for all data. The Maximum Likelihood Linear Transform takes the reduced feature space from the LDA and derives a unique transformation for each speaker. MLLT is therefore a step towards speaker normalization, as it minimizes differences among speakers.  
            
**SAT** stands for Speaker Adaptive Training. SAT also performs speaker and noise normalization by adapting to each specific speaker with a particular data transform. This results in more homogenous or standardized data, allowing the model to use its parameters on estimating variance due to the phoneme, as opposed to the speaker or recording environment.  
            
* **Alignment Algorithms**
            
The actual alignment algorithm will always be the same; the different scripts accept different types of acoustic model input.
            
Speaker independent alignment, as it sounds, will exclude speaker-specific information in the alignment process.  

**fMLLR** stands for Feature Space Maximum Likelihood Linear Regression. After SAT training, the acoustic model is no longer trained on the original features, but on speaker-normalized features. For alignment, we essentially have to remove the speaker identity from the features by estimating the speaker identity (with the inverse of the fMLLR matrix), then removing it from the model (by multiplying the inverse matrix with the feature vector). These quasi-speaker-independent acoustic models can then be used in the alignment process.

<script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
         (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
         m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
         })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
         
         ga('create', 'UA-47182994-2', 'auto');
         ga('send', 'pageview');
         
</script>
