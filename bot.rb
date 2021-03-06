require 'telegram/bot'
require 'nokogiri'
require 'net/http'

  token = '1721382415:AAHCeN8oEHW7gIH3705IAXV_4lng8wWaZRY'


  def scraper (word)
    uri = URI'https://metymology.ch'
    unparsed_page = Net::HTTP.get(uri)


    parsed_page = Nokogiri::HTML(unparsed_page)
    alphabet = parsed_page.css('ul.wpg-list-items')  #has 26 blocks in alphabetical order
   index = word[0].upcase.codepoints.join.to_i - 65 
   letter_block = alphabet[index].css('a')              #specify the letter block to speed up the process
                         
   letter_block.each do |term|
                  if (word.downcase.eql?(term.text.downcase))
                 found_the_word = true;
                 term_uri = URI(term.attributes["href"].value)  
                 unparsed_term = Net::HTTP.get(term_uri)
                 parsed_term = Nokogiri::HTML(unparsed_term)
                 description = parsed_term.css('div.entry-content.clr').text
                 return description
                 
    end
   
   end
  
   return "Sorry, This word isn't in my dictionary"
   end
  

Telegram::Bot::Client.run(token) do |bot|

  bot.listen do |message|
  
    puts "#{message.from.username} : #{message.text}"
   case message.text
    when '/start'

      bot.api.send_message(chat_id:message.chat.id,text:"If you encounter any error, Feel free to contact me @nonofurbeeswax")

    when message.text
if (message.text != '/start')

  bot.api.send_message(chat_id:message.chat.id,text:scraper(message.text))

end

    end
    end
   
end


