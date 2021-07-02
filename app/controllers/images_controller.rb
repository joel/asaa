# frozen_string_literal: true

class ImagesController < ApplicationController
  include Behaveable::ResourceFinder
  include Behaveable::RouteExtractor

  before_action :set_image, only: %i[show edit update destroy]

  # GET /images or /images.json
  def index
    @images = imageable.all

    respond_to do |format|
      format.html { render :index, status: :ok, location: extract(behaveable: @behaveable) }
      format.json { render json: @images, status: :ok, location: extract(behaveable: @behaveable) }
    end
  end

  # GET /images/1 or /images/1.json
  def show
    respond_to do |format|
      format.html { render :show, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
      format.json { render json: @attachment, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
    end
  end

  # GET /images/new
  def new
    @attachment = imageable.new
    respond_to do |format|
      format.html { render :new, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
      format.json { render json: @attachment, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
    end
  end

  # GET /images/1/edit
  def edit
    respond_to do |format|
      format.html { render :edit, status: :ok, location: extract(behaveable: @behaveable, resource: @attachment) }
      format.json do
        render json: @attachment, status: :ok, location: extract(behaveable: @behaveable, resource: @attachment)
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength

  # POST /images or /images.json
  def create
    @attachment = imageable.new(image_params)

    respond_to do |format|
      @attachment.transaction do
        if @attachment.save
          imageable << @attachment if @behaveable

          @attachment.attachment.attach(params[:attachment][:attachment]) if params[:attachment][:attachment]
          @attachment.attachment.analyze if @attachment.attachment.attached?

          format.html do
            redirect_to polymorphic_url([@behaveable, @attachment]), notice: "Attachment was successfully created."
          end
          format.json do
            render json: @attachment, status: :created, location: polymorphic_url([@behaveable, @attachment])
          end
        else
          format.html do
            render :new, status: :unprocessable_entity, location: polymorphic_url([@behaveable, @attachment])
          end
          format.json do
            render json: @attachment.errors, status: :unprocessable_entity,
                   location: polymorphic_url([@behaveable, @attachment])
          end
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /images/1 or /images/1.json
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @attachment.update(image_params)
        format.html do
          redirect_to polymorphic_url([@behaveable, @attachment]), notice: "Attachment was successfully updated."
        end
        format.json { render :edit, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
      else
        format.html do
          render :edit, status: :unprocessable_entity,
                        location: polymorphic_url([@behaveable, @attachment])
        end
        format.json do
          render json: @attachment.errors, status: :unprocessable_entity,
                 location: polymorphic_url([@behaveable, @attachment])
        end
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to extract(behaveable: @behaveable), notice: "Attachment was successfully destroyed." }
      format.json { head :no_content, location: extract(behaveable: @behaveable) }
    end
  end

  private

  # Get Attachment context object.
  #
  # ==== Returns
  # * <tt>ActiveRecord</tt> - Imageable's images or Attachment.
  def imageable
    @behaveable ||= behaveable
    @behaveable ? @behaveable.images : Attachment
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @attachment = imageable.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:attachment).permit(
      :name,
      :attachment
    )
  end
end
