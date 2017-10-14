module Ajd2jkl
    module ContentParser
        class Common
            @names = %w[
                Deprecated
                Description
                ErrorExample
                Error
                Group
                HeaderExample
                Header
                ParamExample
                Param
                Permission
                Private
                SampleRequest
                SuccessExample
                Success
                Use
                Version
            ].freeze

            def initialize
                raise 'Common is a `static` class. It can\'t be instancied'
            end

            def self.check(line)
                if /^\s*\*\s*@api(?<found_common>#{@names.join('|')})\s/ =~ line
                    found_common = $~[:found_common]
                    c = Object.const_get("::Ajd2jkl::ContentParser::CommonContent::#{found_common}").new(line.sub($~[0], ''))
                    return c
                end
                false
            end

            def self.exists?(key)
                !@names.index?(key.replace(/^@api/, '').trim).nil?
            end
        end

        module CommonContent
            # Base Class for Common parser
            # Often in common description you have `type`
            # in apidocjs it's : Return type, e.g. {Boolean},  {Number},  {String}, {Object}, {String[]} (array of strings), ...
            class AbstractCommon
                attr_reader :raw, :description

                def is_multiline?
                    @multiline
                end

                def family
                    return @family = (self.class.to_s.sub('Ajd2jkl::ContentParser::CommonContent::', '').downcase + 's').to_sym unless @family
                    @family
                end

                # the pattern /^\s*\*\s*@apiNAME\s/ is always removed from the raw data
                def initialize(raw)
                    @raw = raw.strip
                    init
                    init_multiline
                end

                def analyze
                    raise 'This method should be overrided'
                end

                protected

                def init
                    @description = nil
                end

                def init_multiline
                    @multiline = false
                end
            end

            class AbstractCommonMultiline < AbstractCommon
                def append_line(line)
                    return unless is_multiline?
                    @description += "\n" + line
                end

                def end_multiline
                    raise 'This method should be overrided in multiline Common parser'
                end

                protected

                def init_multiline
                    @multiline = true
                end
            end
        end
    end
end
require 'ajd2jkl/content_parser/common/abstract_example'
require 'ajd2jkl/content_parser/common/abstract_parametrable'
require 'ajd2jkl/content_parser/common/deprecated'
require 'ajd2jkl/content_parser/common/description'
require 'ajd2jkl/content_parser/common/error_example'
require 'ajd2jkl/content_parser/common/error'
require 'ajd2jkl/content_parser/common/group'
require 'ajd2jkl/content_parser/common/header_example'
require 'ajd2jkl/content_parser/common/header'
require 'ajd2jkl/content_parser/common/param_example'
require 'ajd2jkl/content_parser/common/param'
require 'ajd2jkl/content_parser/common/permission'
require 'ajd2jkl/content_parser/common/private'
require 'ajd2jkl/content_parser/common/sample_request'
require 'ajd2jkl/content_parser/common/success'
require 'ajd2jkl/content_parser/common/success_example'
require 'ajd2jkl/content_parser/common/use'
require 'ajd2jkl/content_parser/common/version'
