# -- coding: utf-8

require "open-uri"
require "nokogiri"
require "fileutils"

INDEX_URL = 'http://bakufu.jp/'
SAVE_DIR = './img'

def get_jpg_url(url)
  d = Nokogiri.HTML(open(url))
  a = Array.new
  d.xpath('//a').each do | n |
    s = n.attribute('href').value
    if /img\.bakufu\.jp/ =~ s
      a << s
    end
  end
  return a
end


def save_jpg(dirpath,url)
  fname = dirpath + '/' + File.basename(url)
  oscmd ="curl -f --connect-timeout 180 --max-time 300 -o \"#{fname}\" #{url}"
  system(oscmd) 
  sleep 3 
end


def get_targeturl
  d = Nokogiri.HTML(open(INDEX_URL))
  h = Hash::new
  d.xpath('//header').each do |n|
    unless n.css('a').text.strip == "" then
      h[n.css('a').text.strip] =  n.css('a').attribute('href').value
    end
  end
  return h
end


def dl_img()
  h = get_targeturl
  h.each_pair { | key , url |
    fdpath = SAVE_DIR + '/' + key[0,50]
    unless FileTest.exist?(fdpath) then
      FileUtils.mkdir(fdpath)
      a = get_jpg_url url
      a.each do |url|
        save_jpg(fdpath,url)
      end
    end
  }
end

dl_img
