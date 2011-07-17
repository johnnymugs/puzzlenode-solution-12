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

def start_wrapper # TODO
  # open file
  # read first line
  # skip a line
  # read body
  test_first_line = 'UREXVIFLJ'
  test_vdecrypt_body = <<eof
ZE VTXVBX LR BRMME CH LKE SOVJH IX IEOXYRFS MQRRYXIWWLHD FAFDOLAQE JGVWOLW. ZE FNECZ 
YFGENBSI WH KSIGK SW HBAV TB QIVD NZH UAOXVR MLDTRY SW OGWUIPG RVINJDL. VT XYS YNHNG 
UJ KVCK QOG YYTQYWGIAM, AV AUCH MRDMTC U HUOCUWRZ IJ DLYOEEQY GQ TUK JFZFGZIAM FRGCK: 
PAXK ARF NGJEGNII, AUCH PRGGV HIYHTUKV, XSHWUOHY JZBUFFINR WLDJGUT NTH RB 
OFGEEYXRBXAQG BT SLF JSUT GNEK AYPLCB OW KC LWFOAWYVF NZH LBYX KSLJLTBXC ZB NWAAF, 
TIN AYPLCB, GRU OLACOAG. XYS MWWTYKQVBN AQ DRZEZZ CK OESZ XF MIM. BOH CMCZ CFIOES 
XYS JJHSVJIEH IX WHR GFFJY ERSG YITFYLOY NY WFCH SV TUK SLHVJHAX UJ NOL OLTU ZLV 
IHAWEQ YXRHYK RF NSIIWWS LS PKVKOCF DNQ GHU HBW VUTMIJHCGQ TUGX YS MZRUYJ, SE VCK 
RWA ORZHCSWIIK, MEJCLH JNVEE HI APMRJMRHY SGHRXIEQY SQD NZ XYS MSPE GOQV AYVLAGK 
FVHQWHN WGTRB UFG OHXWVZPWV. PYKEJS WSOL GNI GFYKLDRTX'J ONLHNGOSE HI LKE SGGK 
HBSW TUK VLHBDHSF KQGZIQPEAZ SW COJ VUOSEIWHWV NBC SWTYJV TUK TICMHHCG UJ 
TCGHHLYORX SHYOAAJ ME O ZWZ MBTXYG NG PAXK TVOWW.
eof
  puts "Possible keywords for the Vigenere cipher:"
  try_keyword = test_first_line
  (0..25).step(3) do |shift_index|
    output_s = "(#{shift_index.to_s}) #{shift_word(try_keyword,shift_index)} "
    output_s += "(#{(shift_index + 1).to_s}) #{shift_word(try_keyword,shift_index + 1)} "
    output_s += "(#{(shift_index + 2).to_s}) #{shift_word(try_keyword,shift_index + 2)}"
    puts output_s
  end
  puts "Which keyword to use? (enter a number or the keyword itself from above)"
  user_input = gets.chomp
  if user_input.to_i.to_s == user_input then # is this really the way to test for int in ruby???
  # user has entered the number of the keyword
    vigenere_keyword = shift_word try_keyword, user_input.to_i
  else
  # user has entered the keyword itself (or bad input)
    vigenere_keyword = user_input.upcase
  end
  # or maybe loop through the rest of the file? -- i mean instead of loading it up top # TODO
  puts vigenere_decipher test_vdecrypt_body, vigenere_keyword # eventually this should write out to a file, yes?
end
start_wrapper
