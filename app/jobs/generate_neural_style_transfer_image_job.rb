class GenerateNeuralStyleTransferImageJob < ApplicationJob
  queue_as :default

  SSH_SERVER_ADDRESS = 'video'
  SSH_SERVER_NEURAL_STYLE_PATH = '/home/ubuntu/Code/neural-style'
  SSH_SERVER_INPUT_PATH = '/home/ubuntu/Art'

  def perform(generated_image)
    @generated_image = generated_image

    # Upload files
    upload_source_images

    # Style transfer
    generate_style_transfer_image

    # Download results
    download_generated_images

    # Save it back to the file
    output_file = File.open("#{output_dir}/out.png")
    generated_image.update_attribute(:image, output_file)
  end

  private

  def upload_source_images
    Rails.logger.info "Uploading images...".colorize(:light_blue)
    system("scp #{content_path} #{SSH_SERVER_ADDRESS}:#{remote_content_path}")
    system("scp #{style_path} #{SSH_SERVER_ADDRESS}:#{remote_style_path}")
  end

  def generate_style_transfer_image
    neural_style_params = {
      gpu: 0,
      backend: 'cudnn',
      print_iter: 1,
      num_iterations: @generated_image.iterations,
      image_size: 875,
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
  end

  def download_generated_images
    Rails.logger.info "Retrieving generated images".colorize(:light_blue)
    FileUtils::mkdir_p output_dir
    system("cp #{content_path} #{output_dir}/#{content_filename}")
    system("cp #{style_path} #{output_dir}/#{style_filename}")
    system("scp '#{SSH_SERVER_ADDRESS}:#{SSH_SERVER_NEURAL_STYLE_PATH}/out*.png' #{output_dir}/")

    system("open #{output_dir}") if Rails.env.development?
  end

  def content_path
    @generated_image.content_image.image.path(:medium)
  end

  def content_filename
    File.basename(content_path)
  end

  def style_path
    @generated_image.style_image.image.path(:medium)
  end

  def style_filename
    File.basename(style_path)
  end

  def remote_content_path
    "#{SSH_SERVER_INPUT_PATH}/#{content_filename}"
  end

  def remote_style_path
    "#{SSH_SERVER_INPUT_PATH}/#{style_filename}"
  end

  def output_dir
    @output_dir ||= "#{Rails.root}/tmp/generated_images/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}"
  end
end
