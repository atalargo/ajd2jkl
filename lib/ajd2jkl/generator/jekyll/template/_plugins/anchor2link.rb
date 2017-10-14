module Anchor2Link
    def anchor_2_link(text)
        r = /href="#api-([^"]*)/
        # t = '<p>These two parameters will allow your app to create an OAuth2 <strong>Access Token</strong>. This token will be the <a href="#api-intro-oauth">oauth</a> endpoint <a href="#api-bob">'
        text = text.to_s
        res = r.match text
        until res.nil?
            b = res.begin(1)
            if res[1].start_with?('intro-', 'tutorial-')
                text = text.sub(res[0], "href=\"/#api-#{res[1]}")
            else
                text = text.sub(res[0], "href=\"/#{res[1].split('-').join('/')}/#api-#{res[1]}")
            end
            res = r.match(text, b)
        end
        text
    end
end

Liquid::Template.register_filter(Anchor2Link)
