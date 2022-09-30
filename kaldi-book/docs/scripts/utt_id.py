#!/bin/sh

#  utt_id.py
#  
#
#  Created by Eleanor Chodroff on 2/22/15.
#

import os

ref = []

with open("full_script_with_numbers_upper.txt") as f:
    for line in f:
        line = line.strip()
        columns = line.split("\t")
        utt = columns[1]
        id = columns[0]
        ref.append([utt, id])

print ref

segments = open("data/train/segments","wb")
wav = open("data/train/wav.scp","wb")
text = open("data/train/text","wb")

glob_index = 0
from glob import glob
for file in glob("transcripts/*.txt"):
    #print file
    glob_index = 0
    with open(file) as f:
        file_id, ext = os.path.splitext(file)
        file_id = os.path.basename(file_id)
        for line in f:
            line = line.strip()
            columns = line.split(",")
            utt = columns[2].strip()
            start = columns[0]
            end = columns[1]
            if utt == "NO_REF":
                continue
            try:
                while ref[glob_index][0] != utt:
                    glob_index += 1
                utt_id = file_id+"_"+ref[glob_index][1]
                segments.write(utt_id+" "+file_id+" "+start+" "+end+"\n")
                text.write(utt_id+" "+utt+"\n")
                wav.write(file_id+" "+"sessions/"+file_id+".wav"+"\n")
                    #print file, start, end, ref[glob_index][1], utt
            except IndexError, e:
                print "Failed to process",file,start
                print utt
                break

segments.close()
wav.close()
text.close()

