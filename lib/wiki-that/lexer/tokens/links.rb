##
# Copyright 2017 Bryan T. Meyers
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

  # Special Characters for Links
  LINK_SPECIAL = %w([)

  ##
  # Lexer module for links and embedded media
  #
  # This module deviates from standard MediaWiki in its use
  # of namespaces and support for media tags. It is not compliant
  # with the Wikimedia Foundation grammar.
  #
  # @author Bryan T. Meyers
  ##
  module Links
    ##
    # Lex any link , internal or external
    ##
    def lex_link

      count = 0
      while match? LINK_SPECIAL
        count += 1
        advance
      end
      append Token.new(:link_start, count)

      while current != "\n" and not end?
        lex_text(%w(: | ] ))
        case current
          when ':'
            append Token.new(:link_namespace)
            advance
          when '|'
            append Token.new(:link_attribute)
            advance
          when ']'
            count = 0
            while current == ']'
              count += 1
              advance
            end
            append Token.new(:link_end, count)
            return
          else
            ## do nothing
        end
      end
    end
  end
end