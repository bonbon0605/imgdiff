require 'test_helper'

class ImgdiffTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Imgdiff::VERSION
  end

  def test_that_it_makes_diff_file
    output = 'test/images/composite_test.jpg'
    system "bundle exec imgdiff #{images[:original]} #{images[:target]} #{output}"

    assert File.exist? output
    assert same_image? Magick::Image.read(images[:composite]).first, Magick::Image.read(output).first

    system "rm #{output}"
  end

  def test_that_it_makes_output_at_the_path_directed_by_3rd_argument
    output_one = 'test/images/composite_test.jpg'
    system "bundle exec imgdiff #{images[:original]} #{images[:target]} #{output_one}"

    output_another = 'test/images/composite_another_test.jpg'
    system "bundle exec imgdiff #{images[:original]} #{images[:target]} #{output_another}"

    assert File.exist? output_one
    assert File.exist? output_another

    system "rm #{output_one}"
    system "rm #{output_another}"
  end

  def test_that_when_3rd_argument_is_not_given_it_makes_output_path_from_two_files_name_with_timestamp
    expect = File.dirname(images[:original]) + '/' + File.basename(images[:original],'.*') + '_' + File.basename(images[:target],'.*') + '_diff_'
    system "bundle exec imgdiff #{images[:original]} #{images[:target]}"
    output = Dir.glob "#{expect}[0-9]*#{File.extname(images[:original])}"
    assert !output.empty?
    output.each{|file| system "rm #{file}"}
  end
end
