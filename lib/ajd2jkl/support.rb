module Ajd2jkl
    module Support
        module StringSupport
            def self.included(base)
                base.extend(SingletonMethods)
            end

            def underscore
                camel_cased_word = self
                return camel_cased_word unless /[-A-Z ]|::/.match(camel_cased_word)
                word = camel_cased_word.to_s.gsub('::'.freeze, '/'.freeze)
                word.gsub!(/(?:(?<=([A-Za-z\d]))|\b)()(?=\b|[^a-z])/) { "#{$1 && '_'.freeze }#{$2.downcase}" }
                word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2'.freeze)
                word.gsub!(/([a-z\d])([A-Z])/, '\1_\2'.freeze)
                word.tr!('-'.freeze, '_'.freeze)
                word.downcase!
                word.gsub(/(\s|_$)/, '')
            end

            module SingletonMethods
                def underscore(camel_cased_word)
                    String.new(camel_cased_word).underscore
                end
            end
        end
    end
end

class String
    include Ajd2jkl::Support::StringSupport
end
