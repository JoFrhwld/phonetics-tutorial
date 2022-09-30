# Installation

Please refer to [http://www.kaldi-asr.org/doc/install.html](http://www.kaldi-asr.org/doc/install.html){target="_blank"} for more details.  
            
1. Prerequisites

* Git  
    
Git is a version control system that let's developers update source code and easily redistribute updates to the users. Git can be installed via homebrew or following instructions [here](https://git-scm.com/book/en/v1/Getting-Started-Installing-Git){target="_blank"}. 
 
* Subversion (svn)  

Subversion is also a [version control system](https://en.wikipedia.org/wiki/Revision_control){target="_blank"} that keeps track of individual changes while developing the source code. Some of the example scripts still depend on this package.  
              
2. Downloading  
            
It is recommended that Kaldi be installed on a machine with good computing power. Following the instructions for downloading Kaldi on this page: [http://kaldi-asr.org/doc/install.html](http://kaldi-asr.org/doc/install.html){target="_blank"}, first direct the terminal to where you would like to install Kaldi, and then type the following:
            

```r
git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream
```
3. Installation  
                
Locate the file `INSTALL` in the downloaded package and follow the instructions there. In short, you'll need to follow the install instructions in `kaldi/tools` and then in `kaldi/src`. The most typical installation should involve the following code, but read the `INSTALL` file just in case:


```r
cd kaldi/tools  
extras/check_dependencies.sh  
make

cd kaldi/src  
./configure  
make depend  
make
```
