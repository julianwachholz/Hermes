module Hermes
  module Helper
    ##
    # Helper module for working with URLs. This helper makes it easy to extract
    # URL titles, shorten URLs and perform other operations using URLs.
    #
    module URL
      ##
      # The URL of the is.gd API.
      #
      # @return [String]
      #
      IS_GD_URL = 'http://is.gd/create.php'

      ##
      # Extracts the title of a URL. If the response page is a non HTML page
      # nil is returned instead of the title.
      #
      # @param  [String] url The URL for which to extract the title.
      # @return [String]
      #
      def url_title(url)
        response = HTTP.get(url)

        # Skip non HTML responses.
        if response.headers['content-type'] \
        and response.headers['content-type'] !~ %r{text/html}
          return
        end

        document = Nokogiri::HTML(response.body)
        title    = document.css('head title').text

        if title and !title.empty?
          return title.gsub(/\s{2,}|\n/, ' ').strip
        else
          return
        end
      end

      ##
      # Shortens a URL and returns the short version.
      #
      # @param  [String] url The URL to shorten.
      # @return [String]
      # @raise  [Faraday::Error::ClientError] Raised when the URL could not be
      #  shortened.
      #
      def shorten_url(url)
        response = HTTP.get(IS_GD_URL, :format => :simple, :url => url)

        if response.success? and !response.body.include?('error: please')
          return response.body.strip
        else
          raise(Faraday::Error::ClientError, response.body)
        end
      end
    end # URL
  end # Helper
end # Hermes
