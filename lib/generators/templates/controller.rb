# coding: utf-8
class Admin::<%= controller_class_name %>Controller < Admin::BaseController
  before_filter :find_<%= singular_table_name %>, :only => [:show, :edit, :update, :destroy, :move_up, :move_down, :move_to_top, :move_to_bottom]

  def index
    return redirect_to session[:filter_<%= plural_table_name %>] if session[:filter_<%= plural_table_name %>] && params[:back] == "true"
    session[:filter_<%= plural_table_name %>] = request.original_url

    @q = <%= class_name %>.search(params[:q])
    @<%= plural_table_name %> = @q.result(distinct: true).order("id desc")

    respond_to do |format|
      format.html { @<%= plural_table_name %> = @<%= plural_table_name %>.page(params[:page]).per_page(50) }
      format.xls { send_data(@<%= plural_table_name %>.to_xls) }
    end
  end

  def new
    @<%= singular_table_name %> = <%= class_name %>.new
  end

  def create
    @<%= singular_table_name %> = <%= class_name %>.new(<%= singular_table_name %>_params)

    respond_to do |format|
      if @<%= singular_table_name %>.save
        format.html { redirect_to [:admin, @<%= singular_table_name %>], notice: '<%= human_name.downcase %> başarıyla oluşturuldu.' }
        format.json { render :show, status: :created, location: @<%= singular_table_name %> }
      else
        format.html { render :new }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    render :edit
  end

  def edit
  end

  def update
    respond_to do |format|
      if @<%= singular_table_name %>.update_attributes(<%= singular_table_name %>_params)
        format.html { redirect_to [:admin, @<%= singular_table_name %>], notice: '<%= human_name.downcase %> başarıyla güncellendi.' }
        format.json { render :show, status: :ok, location: @<%= singular_table_name %> }
      else
        format.html { render :edit }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @<%= singular_table_name %>.destroy
      redirect_to admin_<%= plural_table_name %>_path(back: true), :notice => "<%= human_name %> başarıyla silindi."
    else
      redirect_to @<%= singular_table_name %>, :error => "<%= human_name %> silinemedi."
    end
  end

  def move_up
    @<%= singular_table_name %>.move_higher
    return redirect_to admin_<%= plural_table_name %>_path(back: true)
  end

  def move_down
    @<%= singular_table_name %>.move_lower
    return redirect_to admin_<%= plural_table_name %>_path(back: true)
  end

  def move_to_top
    @<%= singular_table_name %>.move_to_top
    return redirect_to admin_<%= plural_table_name %>_path(back: true)
  end

  def move_to_bottom
    @<%= singular_table_name %>.move_to_bottom
    return redirect_to admin_<%= plural_table_name %>_path(back: true)
  end

  protected

  def find_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= class_name %>.find(params[:id])
  end

  def <%= singular_table_name %>_params
    params.require(:<%= singular_table_name %>).permit(<%= @attributes.map(&:name) %>)
  end

end