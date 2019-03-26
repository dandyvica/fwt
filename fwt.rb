# -----------------------------------------------------------
# Simple Ruby script to generate Five Words Test pages (5 words and 5 topics)
#
# Usage: ruby fwt.rb [nb_pages]
# -----------------------------------------------------------

# Only 5 words from 5 topics are used
NB_WORDS = 5

class FWT
	attr_reader :words, :topics

	# constructor: read all data files and build a hash contaning topics & words
	def initialize

		# list all files in the database: all files should have the .txt extension
		@files = Dir.glob("./db/*.txt")

		# create a hash containing topics as keys, and all word arrays as values
		@db = Hash.new
		@files.each {|f|
			# topic name are merely database file main filename
			topic = File.basename(f, ".txt").upcase

			# load file as an array of strings
			@db[topic] = File.readlines(f).collect {|w| w.chomp}
		}
	end

	# get nb_words words & topics from already read data in ctor
	def get_data(nb_words)
		@topics = @db.keys.sample(nb_words)
		@words = @topics.collect {|topic|
			@db[topic].sample.upcase
		}

	end

	# convert to string
	def to_s
		"words=#{@words}, topics=#{@topics}\n"
	end

end

# -----------------------------------------------------------
# build an ODT (LibreOffice) filled with words and topics
# -----------------------------------------------------------
class XMLTemplate
	def initialize
		@content = File.read("./template/body_template.xml")
	end

	# replace words & topics in the XML template
	def replace(words, topics)
		n = words.length

		# copy XML content
		xml = String.new(@content)

		# for each word and theme, replace
		n.times { |i|

			# change words
			new_word = words[i]
			old_word = "WORD" + (i+1).to_s
			xml.gsub!(old_word,new_word)

			# change topics
			new_topic = topics[i]
			old_topic = "TOPIC" + (i+1).to_s
			xml.gsub!(old_topic,new_topic)
		}
		xml		
	end

	# build the ODT file from the XML template
	def build_odt(xml, filename)
		# open context.xml and replace TEMPLATE with xml string content
		content = File.read("./template/content_template.xml")
		content.gsub!("TEMPLATE", xml)

		# unzip the page.odt file from odt zip
		Dir.mkdir("./odt/tmp")
		`unzip ./odt/page.odt -d ./odt/tmp`

		# replace content.xml
		handle = File.open("./odt/tmp/content.xml", "w")
		handle.print content
		handle.close

		# re-zip whole data
		Dir.chdir("./odt/tmp")
		`zip -r #{filename} .`

		# cleanup
		Dir.chdir("../..")
		`rm -fr ./odt/tmp`

	end
end

# ---------------------------------------------------------------------------------------------------------------------
# build an ODT file containing pair of pages: first page is the list of 5 words, the following one the list of topics
# ---------------------------------------------------------------------------------------------------------------------

# check args
if ARGV.length != 1 then
	puts "fwt.rb [nb_pages]"
	exit
end

# number of pairs (word page, topic page) to build
nb_pages = ARGV[0].to_i

# read database
fwt = FWT.new

# new XML object to handle ODT XML
xml = XMLTemplate.new

# generate page pairs: one page for words, one page for topics (in the same order)
pages = ""
nb_pages.times {|page|

	# get random words & topics
	fwt.get_data(NB_WORDS)
	print fwt

	pages += xml.replace(fwt.words, fwt.topics)
}

# build final ODT
xml.build_odt(pages, "../fwt.odt")












