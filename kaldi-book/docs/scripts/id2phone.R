#!/bin/sh

#  id2phone.R
#  
#
#  Created by Eleanor Chodroff on 3/24/15.
#
phones <- read.table("/Users/Eleanor/mycorpus/recipefiles/phones.txt", quote="\"")
segments <- read.table("/Users/Eleanor/mycorpus/recipefiles/segments.txt", quote="\"")
ctm <- read.table("/Users/Eleanor/mycorpus/recipefiles/merged_alignment.txt", quote="\"")

names(ctm) <- c("file_utt","utt","start","dur","id")
ctm$file <- gsub("_[0-9]*$","",ctm$file_utt)
names(phones) <- c("phone","id")
names(segments) <- c("file_utt","file","start_utt","end_utt")

ctm2 <- merge(ctm, phones, by="id")
ctm3 <- merge(ctm2, segments, by=c("file_utt","file"))
ctm3$start_real <- ctm3$start + ctm3$start_utt
ctm3$end_real <- ctm3$start_utt + ctm3$dur

write.table(ctm3, "Users/Eleanor/mycorpus/recipefiles/final_ali.txt", row.names=F, quote=F, sep="\t")

