require 'erb'

module Ajd2jkl
    module Generator
        module Jekyll
            class Jerb
                def initialize(config, _options, output, output_final)
                    create_site config
                    @source_dir = output
                    @destination_dir = output_final
                    @header = config.key?('header') ? OpenStruct.new(config['header']) : nil
                    @footer = config.key?('footer') ? OpenStruct.new(config['footer']) : nil
                end

                protected

                def create_site(config)
                    @site = OpenStruct.new({
                        title: (config.key?('title') ? config['title'] : 'Your awesome title'),
                        email: (config.key?('email') ? config['email'] : ''),
                        url: (config.key?('url') ? config['url'] :  ''),
                        description: (config.key?('description') ? config['description'] : 'Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.')
                    })
                end

                public

                def build(erbfile)
                    ERB.new(File.read(erbfile), 0, '-').result binding
                end
            end
        end
    end
end
