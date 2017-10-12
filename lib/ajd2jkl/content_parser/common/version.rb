module Ajd2jkl
    module ContentParser
        module CommonContent
            # Common apiVersion parser
            # multiline: false
            # @apiVersion semantic_version
            class Version < AbstractCommon
                attr_reader :version

                def analyze
                    Ajd2jkl.verbose_say('Analyzing Common/Version... ')
                    @version = @raw.gsub(/\s/, '')
                    Ajd2jkl.verbose_say(" Found inclusion in version: `#{@version}`")
                    @raw = nil
                end
            end
        end
    end
end
