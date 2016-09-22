class GeneratedImagesController < ApplicationController
  before_action :set_generated_image, only: [:show, :edit, :update, :destroy]

  # GET /generated_images
  def index
    @generated_images = GeneratedImage.all
  end

  # GET /generated_images/1
  def show
  end

  # GET /generated_images/new
  def new
    @generated_image = GeneratedImage.new(iterations: 500)
    @source_images = SourceImage.all
  end

  # GET /generated_images/1/edit
  def edit
  end

  # POST /generated_images
  def create
    @generated_image = GeneratedImage.new(generated_image_params)

    if @generated_image.save
      redirect_to generated_images_path, notice: 'Generated image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /generated_images/1
  def update
    if @generated_image.update(generated_image_params)
      redirect_to @generated_image, notice: 'Generated image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /generated_images/1
  def destroy
    @generated_image.destroy
    redirect_to generated_images_url, notice: 'Generated image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_generated_image
      @generated_image = GeneratedImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def generated_image_params
      params.require(:generated_image).permit(:image, :content_image_id, :style_image_id, :iterations)
    end
end
