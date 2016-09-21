class GeneratedImage < ApplicationRecord
  has_attached_file :image, styles: { medium: '875x875>', thumb: '150x150>' }
  belongs_to :content_image, class_name: 'SourceImage'
  belongs_to :style_image, class_name: 'SourceImage'

  validates_presence_of :content_image, :style_image
  validates_attachment :image,
    size: { in: 0..20.megabytes },
    content_type: {content_type: /\Aimage\/.*\z/}

  after_create :generate_image

  SSH_SERVER_ADDRESS = 'video'
  SSH_SERVER_NEURAL_STYLE_PATH = '/home/ubuntu/Code/neural-style'
  SSH_SERVER_INPUT_PATH = '/home/ubuntu/Art'

  def generate_image(num_iterations = 50, image_size = 875)
    # Upload files
    content_filename = File.basename(content_path)
    style_filename = File.basename(style_path)

    remote_content_path = "#{SSH_SERVER_INPUT_PATH}/#{content_filename}"
    remote_style_path = "#{SSH_SERVER_INPUT_PATH}/#{style_filename}"

    Rails.logger.info "Uploading images...".colorize(:light_blue)
    system("scp #{content_path} #{SSH_SERVER_ADDRESS}:#{remote_content_path}")
    system("scp #{style_path} #{SSH_SERVER_ADDRESS}:#{remote_style_path}")

    # Style transfer
    neural_style_params = {
      gpu: 0,
      backend: 'cudnn',
      print_iter: 1,
      num_iterations: num_iterations,
      image_size: image_size,
      style_image: remote_style_path,
      content_image: remote_content_path,
    }
    neural_style_params_cli = neural_style_params.to_a.map{|k, v| "-#{k} #{v}"}.join(' ')
    neural_style_cmd = "th neural_style.lua #{neural_style_params_cli}"

    Rails.logger.info "Generating image\n#{neural_style_cmd}".colorize(:light_blue)

    output = system("ssh -t #{SSH_SERVER_ADDRESS} '
          cd #{SSH_SERVER_NEURAL_STYLE_PATH} &&
          rm -f #{SSH_SERVER_NEURAL_STYLE_PATH}/out*.png &&
          #{neural_style_cmd}
       '")

    Rails.logger.info "RESULT: #{output}"

    Rails.logger.info "Retrieving generated images".colorize(:light_blue)
    output_dir = "#{Rails.root}/tmp/generated_images/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
    FileUtils::mkdir_p output_dir
    system("cp #{content_path} #{output_dir}/#{content_filename}")
    system("cp #{style_path} #{output_dir}/#{style_filename}")
    system("scp '#{SSH_SERVER_ADDRESS}:#{SSH_SERVER_NEURAL_STYLE_PATH}/out*.png' #{output_dir}/")

    system("open #{output_dir}") if Rails.env.development?

    output_file = File.open("#{output_dir}/out.png")
    update_attribute(:image, output_file)
  end

  def content_path
    content_image.image.path(:medium)
  end

  def style_path
    style_image.image.path(:medium)
  end
end
