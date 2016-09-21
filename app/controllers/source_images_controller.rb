class SourceImagesController < ApplicationController
  before_action :set_source_image, only: [:show, :edit, :update, :destroy]

  # GET /source_images
  def index
    @source_images = SourceImage.all
  end

  # GET /source_images/1
  def show
  end

  # GET /source_images/new
  def new
    @source_image = SourceImage.new
  end

  # GET /source_images/1/edit
  def edit
  end

  # POST /source_images
  def create
    @source_image = SourceImage.new(source_image_params)

    if @source_image.save
      redirect_to @source_image, notice: 'Source image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /source_images/1
  def update
    if @source_image.update(source_image_params)
      redirect_to @source_image, notice: 'Source image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /source_images/1
  def destroy
    @source_image.destroy
    redirect_to source_images_url, notice: 'Source image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source_image
      @source_image = SourceImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def source_image_params
      params.require(:source_image).permit(:image, :upload_url)
    end
end
