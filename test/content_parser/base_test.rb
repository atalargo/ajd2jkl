require 'test_helper'

class ContentParserBaseTest < Minitest::Test
    def test_that_has_auto_define_some_methods
        @keys = %w[
            uses deprecateds descriptions errors groups
            error_examples headers header_examples params
            param_examples permissions privates sample_requests
            successs success_examples versions
        ]
        %w[
            Define
            Entry
        ].each do |kname|
            object = Object::const_get("Ajd2jkl::ContentParser::#{kname}").new ''
            @keys.each do |m|
                assert_respond_to object, m
            end
        end
    end
end
