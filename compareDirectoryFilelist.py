''' 
This is a script which takes two directories as command line inputs (must be in quotes)
and checks to see what files overlap and which ones do not. 

It may be useful to spit out a csv or txt or something that has that information, 
but currently it just prints to stdout

'''
import sys
import glob
import os

d1 = glob.glob(sys.argv[1])
d2 = glob.glob(sys.argv[2])
d1 = set([os.path.splitext(os.path.basename(x))[0] for x in d1])
d2 = set([os.path.splitext(os.path.basename(x))[0] for x in d2])
matched = d1.intersection(d2)
unmatched = d1.difference(d2)

matched = sorted(list(matched))
unmatched = sorted(list(unmatched))
print('Files matched:')
print('\t'+'\n\t'.join(matched))
print ('Files Not Matched:')
print('\t'+'\n\t'.join(unmatched))
