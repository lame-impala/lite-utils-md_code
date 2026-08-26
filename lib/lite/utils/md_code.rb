# frozen_string_literal: true

require_relative 'md_code/version'
require_relative 'md_code/extraction'
require_relative 'md_code/instance'

module Lite
  module Utils
    module MdCode
      def self.instance(path, dir: nil, tag: :test)
        snippets = Extraction.extract(path, dir, tag)
        Instance.instance snippets
      end
    end
  end
end
