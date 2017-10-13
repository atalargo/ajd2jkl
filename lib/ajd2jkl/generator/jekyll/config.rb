module Ajd2jkl
    module Generator
        module Jekyll
            def self.get_config(config, output, output_final)
                config = <<EOF
title: #{config.key?('title') ? config['title'] : 'Your awesome title'}
email: #{config.key?('email') ? config['email'] :  ''}
description: >- # this means to ignore newlines until "baseurl:"
  #{config.key?('description') ? config['description'] : 'Write an awesome description for your new site here. You can edit this line in _config.yml. It will appear in your document head meta (for Google search results) and in your feed.xml site description.'}

baseurl: "" # the subpath of your site, e.g. /blog
url: "" # the base hostname & protocol for your site, e.g. http://example.com

source: #{output}
destination: #{output_final}

layouts_dir: _layouts
data_dir: _data
includes: _includes
collections:
  - api
#{config.key?('header') || config.key?('footer') ? '  - documentations' : ''}

permalink: pretty

# Build settings
markdown: kramdown
# theme: jekyll-theme-hydejack
plugins: []

redcarpet:
  extensions:
    - smart
    - tables


EOF
            end
        end
    end
end
