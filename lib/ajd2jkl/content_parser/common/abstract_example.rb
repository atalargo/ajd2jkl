module Ajd2jkl
    module ContentParser
        module CommonContent
            # Abstract Common api(Header|Error|Success|Param)Example parser
            # multiline: true
            # @api(Header|Error|Success|Param)Example [{type}] [title]
            #       example <= pre-formatted code.
            class AbstractExample < AbstractCommonMultiline
                attr_reader :type, :title

                # test regexp http://rubular.com/r/UwvIDkAa8b
                @@parser = %r{
                    ^\s*
                        ({(?<type>[A-Za-z]\w*)}\s+)?
                        (?<title>.*)?
                    $
                }x

                def analyze
                    Ajd2jkl.verbose_say("Analyzing Common/#{example_type}... ")
                    match = @@parser.match(@raw)
                    @type = match[:type] unless match[:type].nil?
                    @title = match[:title] unless match[:title].nil?
                    @description = ''
                    @raw = nil
                end

                def example
                    @description
                end

                def end_multiline
                    Ajd2jkl.verbose_say(" Found #{example_type} #{@type ? ' of type '+@type : ''}#{@title ? " with title `#{@title}`" : ''}")
                end

                def example_type
                    return @example_type = self.class.to_s.sub('Ajd2jkl::ContentParser::CommonContent::', '') unless @example_type
                    @example_type
                end

                protected

                def init
                    super
                    @type = @title = @example = @example_type = nil
                end
            end
        end
    end
end
