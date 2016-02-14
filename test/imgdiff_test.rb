require 'test_helper'

class ImgdiffTest < Minitest::Test
  def teardown
    Dir.glob('test/images/*').each do |file|
      File.delete file unless images[:original] == file or images[:target] == file or images[:composite] == file
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Imgdiff::VERSION
  end

  def test_that_it_makes_diff_file
    output = 'test/images/composite_test.jpg'
    ImgDiff.new([images[:original],images[:target], output]).invoke(:exec)

    assert File.exist? output
    assert same_image? Magick::Image.read(images[:composite]).first, Magick::Image.read(output).first
  end

  def test_that_it_makes_output_at_the_path_directed_by_3rd_argument
    output_one = 'test/images/composite_test.jpg'
    ImgDiff.new([images[:original],images[:target], output_one]).invoke(:exec)

    output_another = 'test/images/composite_another_test.jpg'
    ImgDiff.new([images[:original],images[:target], output_another]).invoke(:exec)

    assert File.exist? output_one
    assert File.exist? output_another
  end

  def test_that_when_3rd_argument_is_not_given_it_makes_output_path_from_two_files_name_with_timestamp
    expect = File.dirname(images[:original]) + '/' + File.basename(images[:original],'.*') + '_' + File.basename(images[:target],'.*') + '_diff_'
    ImgDiff.new([images[:original],images[:target]]).invoke(:exec)
    output = Dir.glob "#{expect}[0-9]*#{File.extname(images[:original])}"
    assert !output.empty?
  end

  def test_that_when_image_file_not_exist_it_ends_with_exception
    assert_raises RuntimeError do
      ImgDiff.new(['test/images/not_found_image.jpg',images[:target]]).invoke(:exec)
    end
    assert_raises RuntimeError do
      ImgDiff.new([images[:original],'test/images/not_found_image.jpg']).invoke(:exec)
    end
    assert_raises RuntimeError do
      ImgDiff.new(['test/images/not_found_image.jpg','test/images/not_found_image.jpg']).invoke(:exec)
    end
  end

  def test_it_can_overwrite_the_output_file
    output = 'test/images/composite_test.jpg'

    ImgDiff.new([images[:original],images[:target],output]).invoke(:exec)
    assert_equal true, same_image?(Magick::Image.read(output).first, Magick::Image.read(images[:composite]).first)

    ImgDiff.new([images[:original],images[:composite],output]).invoke(:exec)
    assert_equal false, same_image?(Magick::Image.read(output).first, Magick::Image.read(images[:composite]).first)
  end

  def test_it_does_not_make_diff_file_when_there_is_no_diff_between_two_files
    output = 'test/images/composite_test.jpg'

    assert_output "There is no diff between the files\n" do
      ImgDiff.new([images[:original],images[:original],output]).invoke(:exec)
    end

    assert_equal false, File.exist?(output)
  end

end
