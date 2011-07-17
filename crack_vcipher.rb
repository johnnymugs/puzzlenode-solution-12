def build_alphabet
  ('A'..'Z').to_a
end

def shift_letter(letter, shift_index) #seems like we should use symbols...
  alphabet = build_alphabet
  original_index = alphabet.index(letter.upcase)
  new_index = (original_index + shift_index) % 26
  return alphabet[new_index]
end

def unshift_letter(letter, shift_index) #this doesn't feel dry broseph :(
  alphabet = build_alphabet
  original_index = alphabet.index(letter.upcase)
  new_index = (original_index - shift_index) % 26
  return alphabet[new_index]
end

def shift_word(word, shift_index)
  new_word = "" # necessary?
  word.chars.each do |char|
    new_word += shift_letter char, shift_index
  end
  new_word
end

def vigenere_decipher(phrase,keyword)
  new_phrase = ""
  ref_alphabet = build_alphabet
  keyword_step = 0
  phrase.chars.each do |char|
    if ref_alphabet.index char then
      keyword_index = keyword_step % keyword.length
      shift_index = ref_alphabet.index keyword[keyword_index]
      new_phrase += unshift_letter char, shift_index
      keyword_step += 1
    else
      new_phrase += char
    end
  end
  new_phrase
end

# now begin the actual cracking of the code in the file...
file = File.new(ARGV.first)
initial_caesar_encrypted_keyword = file.gets.chomp
file.gets # skip a line
vdecrypt_body = ""
while(next_line = file.gets) do
  vdecrypt_body += next_line
end
file.close # done reading the file

# now present the possible solutions to the caesar cipher to the user and wait for input
puts "Possible keywords for the Vigenere cipher:"
try_keyword = initial_caesar_encrypted_keyword
(0..25).step(3) do |shift_index| # display three at a time for the sake of readability
  output_s = ""
  3.times do |i|
    output_s += "(#{(shift_index + i).to_s}) #{shift_word(try_keyword,(shift_index + i))} "
  end
  puts output_s
end

puts "Which keyword to use? (enter a number or the keyword itself from above)"
user_input = STDIN.gets.chomp # user can either enter the index from above or the keyword itself, we're not picky...
if user_input.to_i.to_s == user_input then # is this really the way to test for int in ruby???
# user has entered the number of the keyword
  vigenere_keyword = shift_word try_keyword, user_input.to_i
else
# user has entered the keyword itself (or bad input)
  vigenere_keyword = user_input.upcase
end
puts vigenere_decipher vdecrypt_body, vigenere_keyword
