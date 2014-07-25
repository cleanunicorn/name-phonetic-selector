fs = require 'fs'
levenshtein = require 'levenshtein'
natural  = require 'natural'
metaphone = natural.Metaphone

filename = process.argv[2]

file_data = fs.readFileSync \
	filename
	, encoding: 'utf-8'

words = file_data.split "\n"
# Trim words
words = words.map \
	(w)->
		w.trim().toLowerCase()
# Unique words
words_unique = []
for w in words
	if words_unique.indexOf(w) < 0
		words_unique.push w
words = words_unique

fs.writeFile filename, words.join("\n")

words_distance = []

for a, index in words
	console.log "#{index}"

	for b_index in [index..words.length-1]
		b = words[b_index]

		continue if a is b
		# continue if a.length <= 3

		metaphone_a = metaphone.process(a)
		metaphone_b = metaphone.process(b)

		metaphone_distance = new levenshtein metaphone_a, metaphone_b

		words_distance.push \
			"distance": metaphone_distance.distance
			# , "phonetics":
			, "a": a
			, "b": b
			, "metaphone_a": metaphone_a
			, "metaphone_b": metaphone_b

words_distance.sort (a, b)->
	return -1 if a.distance > b.distance
	return 1 if a.distance < b.distance
	return 0 if a.distance is b.distance


for sintagm in words_distance
	console.log "#{sintagm.distance} #{sintagm.a} #{sintagm.b}"



