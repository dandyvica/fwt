# A Ruby script to generate five-word test pages
## The five-word test (or Dubois's test)
The FWT is a word-memory test once used to identify and fast screen 
Alzheimer’s. The test focuses on the recall of a short list of words and corresponding topic a patient is asked to remember, with a second step using cued hints. It's not the only screening used for this purpose, and it should not be used solely to identify someone's disease.

_Disclaimer_: I'm not a physician. I just wrote this script to help generating other tables found on the internet.

## The Ruby script
`fwt.rb` is a simple Ruby script to generate an OpenOffice document which contains pair of pages: one with 5 words, and the next one with five corresponding topics. The ODT coument could be easily concerted to a PDF file for printing.

The script is reading data files in the `db` subdirectory. Ex:

```command
$ ls db
animal.txt  capitale.txt  departement.txt  fleur.txt  fruit.txt  legume.txt  pays.txt  sports.txt  transport.txt
```

Each file contains a list of words, one word per line:

```command
$ cat animal.txt
AGNEAU
AIGLE
ALLIGATOR
ALPAGA
ANE
ANTILOPE
...
```

and therefore could be easily translated or changed to match specific requirements.

To use the script:

```command
$ ruby fwt.rb 100
```
generates 100 pairs of pages with 5 words, and corresponding topics. The final ODT document is created in the `odt` subdirectory as `fwt.odt`. The 5 words are randomly taken inside each of the topics files. So calling the script twice leads to different results.

To add a topic, just add a file with the corresponding list of words. For example if you want to add a `MONKEY` topic, just add a `monkey.txt` file in the  `db` subdirectory with the list of monkey inside.

To delete a topic, just delete the file in the `db` subdirectory.

Feel free to modify the script to fit your requirements.

The sample file in the `odt` directory was generated with:

```command
$ ruby fwt.rb 200
```

