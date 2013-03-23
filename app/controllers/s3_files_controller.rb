class S3FilesController < ApplicationController

  respond_to :json, only: [:create]

  before_filter :set_s3_file, except: [:index, :create]
  before_filter :build_attributes, only: [:create]


  def index
    @s3_files = S3File.uploaded.all
  end

  def create
    @s3_file = S3File.new(@attributes, as: :create)
    if @s3_file.save
      url = S3Tools.object_url_for(@s3_file.s3_key, :put, headers: {'content-type' => @s3_file.content_type})
      render json: {id: @s3_file.id, s3_upload_url: url, s3_upload_method: :put, s3_upload_content_type: @s3_file.content_type}, status: :created
    else
      render json: @s3_file.errors, status: :unprocessable_entity
    end
  end

  def uploaded
    @s3_file.uploaded!
    redirect_to action: :index
  end

  def download
    url = S3Tools.object_url_for(@s3_file.s3_key, :get, response_content_type: @s3_file.content_type)
    redirect_to url
  end

  def destroy
    S3Tools.delete_object(@s3_file.s3_key, :delete)
    @s3_file.destroy
    redirect_to action: :index
  end

  private

  def set_s3_file
    @s3_file = S3File.find(params[:id])
  end

  def build_attributes
    accessible_attributes = S3File.accessible_attributes(action_name.to_sym).map(&:to_sym)
    @attributes = params[:s3_file].slice(*accessible_attributes)
  end

end
