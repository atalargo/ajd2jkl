require 'ajd2jkl/content_parser/common'

module Ajd2jkl
    module ContentParser
        class AbstractParser
            attr_reader :analyzed, :title

            @@keynames = %w[
                uses deprecateds descriptions errors groups
                error_examples headers header_examples params
                param_examples permissions privates sample_requests
                successs success_examples versions
            ].freeze

            protected

            def initialize(definition, verbose = false)
                @verbose = verbose
                @definition = definition
                @analyzed = false
            end

            def parse_first_line(line)
                raise "Method `parse_first_line`should be overrided"
            end

            public

            def self.parse(definition, verbose = false)
                d = new(definition, verbose)
                d.parse
                d
            end

            def from_file
                @definition.from_file
            end

            def from_line
                @definition.from_line
            end

            def name
                @definition.name
            end

            def parse
                @description = ''
                @contents = {}
                last_c = nil
                @definition.content.each_with_index do |line, idx|
                    if idx == 0
                        parse_first_line(line)
                    else
                        c = Common.check(line)
                        if c
                            if last_c
                                last_c.end_multiline
                                last_c = nil
                            end
                            c.analyze
                            @contents.key?(c.family) ? @contents[c.family].push(c) : @contents[c.family] = [c]
                            last_c = c if c.is_multiline?
                        else
                            line = line.sub(/^\s*\*\s?/, '')
                            last_c ? last_c.append_line(line) : @description += line
                        end
                    end
                end
                last_c.end_multiline if last_c
                last_c = nil
                @definition.clear_content
                @analyzed = true
            end

            def method_missing(methId)
                raise "Method missing `#{methId.id2name}`" unless respond_to_missing?(methId.id2name)
                nmeth = methId.id2name.sub(/\?$/, '')
                self.class.class_eval %Q{def #{nmeth}? \n @contents.key?(:#{nmeth}) \n end}
                self.class.class_eval %Q{def #{nmeth} \n @contents[:#{nmeth}] \n end}
                public_send methId
            end

            def respond_to_missing?(method_name, include_private = false)
                @@keynames.include?(method_name.to_s.sub(/\?$/, '')) || super
            end

            # def uses?
            #     @contents.key?(:uses)
            # end
            #
            # def uses
            #     @contents[:uses]
            # end
        end
    end
end
