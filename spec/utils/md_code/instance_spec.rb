# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/lite/utils/md_code/instance'

module Lite
  module Utils
    module MdCode
      RSpec.describe Instance do
        let(:instance) { described_class.instance({ foo: "'FOO'\n", bar: "'BAR'\n" }) }

        describe '#ensure_consumed!' do
          context "when some snippets haven't been consumed" do
            it 'raises error' do
              expect { instance.ensure_consumed! }
                .to raise_error(Error, "Some snippets haven't been consumed: foo, bar")
            end
          end

          context 'when all snippets haven been consumed' do
            before do
              instance.snippet!(:foo)
              instance.snippet!(:bar)
            end

            it "doesn't raise error" do
              expect { instance.ensure_consumed! }
                .not_to raise_error
            end
          end
        end
      end
    end
  end
end
