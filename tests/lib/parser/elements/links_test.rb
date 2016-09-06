require 'test/unit'
require_relative('../../../../lib/wiki-that/parser/parser')
class LinkTest < Test::Unit::TestCase

  def setup
    WikiThat.base_url='wiki'
    WikiThat.default_namespace='BOB'
    WikiThat.sub_url='sub/folder'
  end

  def test_empty
    i,text = WikiThat::Parser.parse('',0)
    assert_equal(0,i,'Link should not advance')
    assert_equal('',text,'Nothing should have been generated')
  end

  def test_external_unbalanced
    i,text = WikiThat::Parser.parse('[',0)
    assert_equal(1,i,'Link should advance')
    assert_equal('[',text,'Empty link should have been generated')
  end

  def test_external_empty
    i,text = WikiThat::Parser.parse('[]',0)
    assert_equal(2,i,'Link should advance')
    assert_equal('<a href=\'\'></a>',text,'Empty link should have been generated')
  end

  def test_external
    i,text = WikiThat::Parser.parse('[http://example.com]',0)
    assert_equal(20,i,'Link should advance')
    assert_equal('<a href=\'http://example.com\'></a>',text,'Valid link should have been generated')
  end

  def test_external_alt
    i,text = WikiThat::Parser.parse('[http://example.com|Example]',0)
    assert_equal(28,i,'Link should advance')
    assert_equal('<a href=\'http://example.com\'>Example</a>',text,'Valid link should have been generated')
  end

  def test_internal_incomplete
    i,text = WikiThat::Parser.parse('[[',0)
    assert_equal(2,i,'Link should advance')
    assert_equal('[[',text,'Link should not have been generated')
  end

  def test_internal_incomplete2
    i,text = WikiThat::Parser.parse('[[]',0)
    assert_equal(3,i,'Link should advance')
    assert_equal('[[]',text,'Link should not have been generated')
  end

  def test_internal_empty
    i,text = WikiThat::Parser.parse('[[]]',0)
    assert_equal(4,i,'Link should advance')
    assert_equal('<a href=\'wiki/BOB/\'></a>',text,'Link should have been generated')
  end

  def test_internal_home
    i,text = WikiThat::Parser.parse('[[public/Home]]',0)
    assert_equal(15,i,'Link should advance')
    assert_equal('<a href=\'wiki/BOB/public/Home\'></a>',text,'Link should have been generated')
  end

  def test_internal_relative
    i,text = WikiThat::Parser.parse('[[/public/Home]]',0)
    assert_equal(16,i,'Link should advance')
    assert_equal('<a href=\'wiki/BOB/sub/folder/public/Home\'></a>',text,'Link should have been generated')
  end

  def test_internal_audio
    i,text = WikiThat::Parser.parse('[[Audio:public/test.wav]]',0)
    assert_equal(25,i,'Link should advance')
    assert_equal('<audio controls><source src=\'wiki/BOB/public/test.wav\'></audio>',text,'Link should have been generated')
  end

  def test_internal_video
    i,text = WikiThat::Parser.parse('[[Video:public/test.wav]]',0)
    assert_equal(25,i,'Link should advance')
    assert_equal('<video controls><source src=\'wiki/BOB/public/test.wav\'></video>',text,'Link should have been generated')
  end

  def test_internal_image
    i,text = WikiThat::Parser.parse('[[Image:public/test.png]]',0)
    assert_equal(25,i,'Link should advance')
    assert_equal('<img src=\'wiki/BOB/public/test.png\'>',text,'Link should have been generated')
  end
  def test_internal_image_caption
    i,text = WikiThat::Parser.parse('[[Image:public/test.png|Test PNG]]',0)
    assert_equal(34,i,'Link should advance')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\'></div>',text,'Link should have been generated')
  end

  def test_internal_image_frame
    i,text = WikiThat::Parser.parse('[[Image:public/test.png|frame|Test PNG]]',0)
    assert_equal(40,i,'Link should advance')
    assert_equal('<div class=\'frame\'><img src=\'wiki/BOB/public/test.png\'><caption>Test PNG</caption></div>',text,'Link should have been generated')
  end

  def test_internal_image_thumb
    i,text = WikiThat::Parser.parse('[[Image:public/test.png|thumb|Test PNG]]',0)
    assert_equal(40,i,'Link should advance')
    assert_equal('<div class=\'thumb\'><a href=\'wiki/BOB/public/test.png\'><img src=\'wiki/BOB/public/test.png\'></a><caption>Test PNG</caption></div>',text,'Link should have been generated')
  end

  def test_internal_image_width
    i,text = WikiThat::Parser.parse('[[Image:public/test.png|100px|Test PNG]]',0)
    assert_equal(40,i,'Link should advance')
    assert_equal('<div><img src=\'wiki/BOB/public/test.png\' width=\'100px\'></div>',text,'Link should have been generated')
  end

  def test_internal_image_left
    i,text = WikiThat::Parser.parse('[[Image:public/test.png|left|Test PNG]]',0)
    assert_equal(39,i,'Link should advance')
    assert_equal('<div class=\'left\'><img src=\'wiki/BOB/public/test.png\'></div>',text,'Link should have been generated')
  end
end