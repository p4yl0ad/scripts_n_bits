#!/usr/bin/python3

#p4yl0ad/git-xtractor
import zlib  # A compression / decompression library
filename = input("input your dir and file name e.g. 27/9de19bb2d2d6434b8b29ar573ad8c2e48s5391 > ")
compressed_contents = open(filename, 'rb').read()
decompressed_contents = zlib.decompress(compressed_contents)
print(str(decompressed_contents))


#TODO
#add ability to parse newlines so it doesn't look so shit
#option to recursively extract every object in a dir :)
