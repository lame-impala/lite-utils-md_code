# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/lite/utils/md_code/extraction'

module Lite
  module Utils
    module MdCode
      RSpec.describe Extraction do
        describe '#extract' do
          context 'with duplicate code block identifiers' do
            it 'raises error' do
              expect { described_class.extract('../fixtures/duplicate.md', __dir__, 'test') }
                .to raise_error(Error, 'Duplicate test key: foo')
            end
          end

          context 'with valid document' do
            it 'extracts snippets into hash' do
              expect(described_class.extract('../fixtures/valid.md', __dir__, 'test'))
                .to eq(foo: "\"FOO\"\n", bar: "'BAR'\n")
            end
          end
        end
      end
    end
  end
end
