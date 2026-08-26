# frozen_string_literal: true

require 'lite/data'

require_relative 'error'

module Lite
  module Utils
    module MdCode
      class Instance
        Lite::Data.define(self, args: %i[snippets usage])

        def self.instance(snippets)
          new snippets, {}
        end

        def initialize(snippets, usage)
          super(snippets.freeze, usage)
        end

        def snippet!(key)
          consume key, true
        end

        def snippet(key)
          consume key, false
        end

        def consume(key, deplete)
          raise Error, "Snippet not defined: #{key}" unless snippets.key?(key)
          raise Error, "Key already used: #{key}" if usage[key] == :depleted

          case usage[key]
          when nil, :consumed then usage[key] = deplete ? :depleted : :consumed
          end
          snippets[key]
        end

        def ensure_consumed!
          unconsumed = snippets.keys - usage.keys

          raise Error, "Some snippets haven't been consumed: #{unconsumed.join(', ')}" unless unconsumed.empty?
        end
      end
    end
  end
end
