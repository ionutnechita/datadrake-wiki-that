##
# Copyright 2017-2018 Bryan T. Meyers
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
##

module WikiThat

  # Special characters for Headers
  HEADER_SPECIAL = %w(=)

  ##
  # Lexer module for handling headers
  # @author Bryan T. Meyers
  ##
  module Header
    ##
    # Lex the current line as a header
    ##
    def lex_header
      #Read start sequence
      buff = ''
      while match? HEADER_SPECIAL
        buff += current
        advance
      end

      if buff.length < 2
        # Plain old equals
        rewind
        lex_text
        return
      else
        append Token.new(:header_start, buff)
      end

      #Read inner content
      lex_text(HEADER_SPECIAL)

      #closing tag
      buff = ''
      while match? HEADER_SPECIAL
        buff += current
        advance
      end

      case buff.length
        when 0
          # Didn't find a header close
        when 1
          # Just an Equals
          rewind
        else
          append Token.new(:header_end, buff)
      end

      #trailing text
      lex_text
    end
  end
end