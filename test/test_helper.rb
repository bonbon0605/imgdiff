$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'imgdiff'

require 'minitest/autorun'
def images
  {
    original: 'test/images/original.jpg',
    target: 'test/images/target.jpg',
    composite: 'test/images/composite.jpg'
  }
end

def same_image?(original,target)
  return false unless original.instance_of? Magick::Image and target.instance_of? Magick::Image
  return true if original.difference(target) == [0.0,0.0,0.0]
  return false
end
