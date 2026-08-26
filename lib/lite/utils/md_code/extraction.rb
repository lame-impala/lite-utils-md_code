# frozen_string_literal: true

require 'markly'

require_relative 'error'

module Lite
  module Utils
    module MdCode
      module Extraction
        def self.extract(path, dir, tag)
          extract_each(Markly.parse(read(path, dir)), tag)
        end

        def self.extract_each(doc, tag)
          specs = {}
          regex = Regexp.new("^\\S+\\s+#{tag}\\s+(\\S+)$")

          doc.walk do |node|
            next unless node.type == :code_block
            next unless (match = regex.match(node.fence_info))

            key = match[1].to_sym
            raise Error, "Duplicate #{tag} key: #{key}" if specs.key?(key)

            specs.store(key, node.string_content.freeze)
          end

          specs.freeze
        end

        def self.read(path, dir)
          full_path(path, dir).read
        end

        def self.full_path(path, dir)
          dir ? Pathname.new(dir).join(path) : Pathname.new(path)
        end
      end
    end
  end
end
