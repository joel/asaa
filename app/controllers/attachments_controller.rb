# frozen_string_literal: true

class AttachmentsController < ApplicationController
  include Behaveable::ResourceFinder
  include Behaveable::RouteExtractor

  before_action :set_attachment, only: %i[show edit update destroy]

  # GET /attachments or /attachments.json
  def index
    @attachments = attachable.all

    respond_to do |format|
      format.html { render :index, status: :ok, location: extract(behaveable: @behaveable) }
      format.json { render json: @attachments, status: :ok, location: extract(behaveable: @behaveable) }
    end
  end

  # GET /attachments/1 or /attachments/1.json
  def show
    respond_to do |format|
      format.html { render :show, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
      format.json { render json: @attachment, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
    end
  end

  # GET /attachments/new
  def new
    @attachment = attachable.new
    respond_to do |format|
      format.html { render :new, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
      format.json { render json: @attachment, status: :ok, location: polymorphic_url([@behaveable, @attachment]) }
    end
  end

  # GET /attachments/1/edit
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

  # POST /attachments or /attachments.json
  def create
    @attachment = attachable.new(attachment_params)

    respond_to do |format|
      @attachment.transaction do
        if @attachment.save
          attachable << @attachment if @behaveable

          @attachment.asset.attach(params[:attachment][:asset]) if params[:attachment][:asset]
          @attachment.asset.analyze if @attachment.asset.attached?

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

  # PATCH/PUT /attachments/1 or /attachments/1.json
  def update
    respond_to do |format|
      if @attachment.update(attachment_params)
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

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # DELETE /attachments/1 or /attachments/1.json
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
  # * <tt>ActiveRecord</tt> - Attachmentable's attachments or Attachment.
  def attachable
    @behaveable ||= behaveable
    @behaveable ? @behaveable.attachments : Attachment
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_attachment
    @attachment = attachable.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def attachment_params
    params.require(:attachment).permit(
      :name,
      :asset
    )
  end
end
