# frozen_string_literal: true

require_relative '../../../lib/lite/utils/md_code'

module Lite
  module Utils
    module MdCode
      # rubocop:disable Security/Eval
      eval(
        MdCode.instance('../../../README.md', dir: __dir__).snippet!(:extract_snippets),
        binding.tap { _1.local_variable_set(:__dir__, __dir__) }
      )
      eval(SPECS.snippet!(:rspec_config))

      RSpec.describe 'README.md' do
        # rubocop:disable-next RSpec/LeakyConstantDeclaration
        SPECS = MdCode::SPECS.with(
          snippets: MdCode::SPECS
                    .snippets
                    .merge(rspec_example: MdCode::SPECS.snippet(:rspec_example).split("\n")[1..-2].join("\n"))
        )

        describe '#snippet' do
          it 'consumes snippet' do
            SPECS.snippet(:extract_snippets)
            expect(SPECS.usage[:extract_snippets]).to eq(:consumed)
          end
        end

        eval(SPECS.snippet!(:rspec_eval))
      end
      # rubocop:enable Security/Eval
    end
  end
end
