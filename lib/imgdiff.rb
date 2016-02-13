require "imgdiff/version"

require 'thor'
require 'thor/group'
require 'rmagick'

class ImgDiff < Thor::Group
  argument :original_image_path,:required => true
  argument :target_image_path,:required => true
  argument :composite_image_path,:required => false

  def exec
    original,target,output = original_image_path,target_image_path,composite_image_path

    # when output file name is not given, make it from file names with timestamp
    output = File.basename(original,".*") + "_" + File.basename(target,".*") + "_diff_" + Time.now.strftime("%Y%m%d%H%M%S") + File.extname(original) if output.nil?

    raise "ERROR: #{original} is not found" unless File.exist?(original)
    raise "ERROR: #{target} is not found" unless File.exist?(target)

    original = Magick::Image.read(original).first
    target = Magick::Image.read(target).first

    original.composite(target,Magick::CenterGravity,Magick::DifferenceCompositeOp).write(output)
  end
end

ImgDiff.start
