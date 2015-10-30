require "kuromoji/version"
require 'rjb'

module Kuromoji
  jar = File.expand_path("../../vendor/kuromoji-0.7.7/lib/kuromoji-0.7.7.jar", __FILE__)
  Rjb::load(jar)
  @@tokenizer = Rjb::import('org.atilika.kuromoji.Tokenizer').builder.build

  def self.dictionary(path)
    @@tokenizer = Rjb::import('org.atilika.kuromoji.Tokenizer').builder.userDictionary(path).build
  end

  def self.tokenize(sentence)
    process(:all_features, sentence)
  end

  def self.reading(sentence)
    process(:getReading, sentence)
  end

  def self.process(method, sentence)
    list = @@tokenizer.tokenize(sentence)
    iterator = list.iterator
    tokenized = {}
    while iterator.has_next
      item = iterator.next
      tokenized[item.surface_form] = item.send(method)
    end
    tokenized
  end
end
