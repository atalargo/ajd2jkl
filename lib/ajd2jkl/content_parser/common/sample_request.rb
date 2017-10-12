module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiSampleRequest parser
            # multiline: false
            # @apiSampleRequest url
            class SampleRequest < AbstractCommon
                attr_reader :url

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/SampleRequest... ')
                    @url = @raw.gsub(/\s/, '').lstrip
                    Ajd2jkl.verbose_say(" Found url: `#{url}`")
                    @raw = nil
                end
            end
        end
    end
end
