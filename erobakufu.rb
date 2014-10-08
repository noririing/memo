# -- coding: utf-8

require "open-uri"
require "nokogiri"

doc = Nokogiri.HTML(open("http://bakufu.jp/"))

def get_jpg(url)
  d = Nokogiri.HTML(open(url))
  d.xpath('//a').each do | n |
    s = n.attribute('href').value
    if  /img\.bakufu\.jp/ =~ s
      #puts s
      save_jpg s
    end
  end
end

def save_jpg(url)
    filename = File.basename(url)
    open(filename, 'wb') do |file|
        open(url) do |data|
            file.write(data.read)
      end
    end
end

h = Hash::new

doc.xpath('//header').each do | node |
  #p node.css('a').text.strip
  #p node.css('a').attribute('href').value
  h[node.css('a').text.strip] =  node.css('a').attribute('href').value
end

#p h

h.each_pair { | key , value |
  unless key == "" then
    get_jpg value
  end
}

